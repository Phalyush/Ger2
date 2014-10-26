using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Drawing;

public partial class cut : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Bitmap myBitmap = new Bitmap(HttpContext.Current.Server.MapPath("~/images/1.JPG"));
        Bitmap bp = new Bitmap(500, 500);
        // One hand of the runner
        Rectangle sourceRectangle = new Rectangle(500, 500, 500,500);

        // Compressed hand
        Rectangle destRectangle1 = new Rectangle(0, 0, 0, 0);


        // Draw the original image at (0, 0).
        Graphics myGraphics = Graphics.FromImage(bp);
        myGraphics.DrawImage(myBitmap, 0, 0);

        // Draw the compressed hand.
        myGraphics.DrawImage(
           myBitmap, destRectangle1, sourceRectangle, GraphicsUnit.Pixel);

        bp.Save(HttpContext.Current.Server.MapPath("~/images/11.JPG"));

    }
}