<%@ WebHandler Language="C#" Class="Handler" %>

using System;
using System.Web;
using System.IO;
using System.Web.Configuration;
using System.Data.SqlClient;
using System.Drawing;
using System.Drawing.Imaging;
public class Handler : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {

        string fileName = HttpContext.Current.Request.QueryString["FileName"].ToString();
        string catalog = "images/";
        string path = context.Server.MapPath("~/" + catalog);
        using (FileStream fs = File.Create(path + "Temporary"+fileName))
        {
            Byte[] buffer = new Byte[64 * 1024];
            int read = context.Request.GetBufferlessInputStream().Read(buffer, 0, buffer.Length);
            while (read > 0)
            {
                fs.Write(buffer, 0, read);
                read = context.Request.GetBufferlessInputStream().Read(buffer, 0, buffer.Length);
        }
            
       string connString = WebConfigurationManager.ConnectionStrings["connString"].ConnectionString;
        SqlConnection conn = new SqlConnection(connString);
        SqlCommand cmd = new SqlCommand("INSERT INTO img (url) VALUES (@url);", conn);
        cmd.Parameters.AddWithValue("url", catalog + fileName);
        conn.Open();
        int rowsAffected = cmd.ExecuteNonQuery();
        conn.Close();
        }
        
        // Get a bitmap.
        Bitmap bmp1 = new Bitmap(path + "Temporary" + fileName);
        ImageCodecInfo jgpEncoder = GetEncoder(ImageFormat.Jpeg);

        // Create an Encoder object based on the GUID
        // for the Quality parameter category.
        Encoder myEncoder = Encoder.Quality;

        // Create an EncoderParameters object.
        // An EncoderParameters object has an array of EncoderParameter
        // objects. In this case, there is only one
        // EncoderParameter object in the array.
        EncoderParameters myEncoderParameters = new EncoderParameters(1);

        EncoderParameter myEncoderParameter = new EncoderParameter(myEncoder, 20L);
        myEncoderParameters.Param[0] = myEncoderParameter;
        bmp1.Save(path + fileName, jgpEncoder, myEncoderParameters);

        Bitmap bp = new Bitmap(100, 100);
        using (Graphics g = Graphics.FromImage(bp))
        {
            //Сглаживание и интерполяция
            g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;
            g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;
            g.PixelOffsetMode = System.Drawing.Drawing2D.PixelOffsetMode.HighQuality;
            //Изменение размера
            g.DrawImage(bmp1,0,0,100,100);
            bp.Save(path +"Small_"+ fileName);
        }
        
        bmp1.Dispose();
        File.Delete(path + "Temporary" + fileName);
        
        

    }
    private ImageCodecInfo GetEncoder(ImageFormat format)
    {
        ImageCodecInfo[] codecs = ImageCodecInfo.GetImageDecoders();
        foreach (ImageCodecInfo codec in codecs)
            if (codec.FormatID == format.Guid)
                return codec;
        return null;
    }
    
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}