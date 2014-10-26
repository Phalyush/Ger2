<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="js/jquery-2.1.0.min.js"></script>
    <script src="js/ajaxupload.3.5.js"></script>
    <link href="css/styles.css" rel="stylesheet" />
    <style>
        #progress {
            width: 450px;
            height:200px;
            overflow:auto;
        }
        .progress-striped {
            border:1px solid #0094ff;
            border-radius:5px;
            width: 200px; height: 20px;
        }
        .Progress {
            width: 200px;
            height: 20px;
            text-align:center;
            vertical-align:middle;
            font-size: 18px;
	        color: #666;
	        text-shadow: -1px -1px 1px #000, 1px 1px 1px #fff;

        }
        .nameFile {
            width:100px;
            height:20px;
            overflow: hidden;
        }
        .liniya { 
        float:left; 
        margin-left:5px; 
        }
        .ovver {
            width:100px;
            height:20px;
            margin-left:-100px;
            background-image:url(img/OverG.png);
            
        }
        .bar {
            width:0%;
            height:20px;
            background-color:#0094ff;
            border-radius:5px;
        }


    </style>
<script type="text/javascript">
    var currFile = 0;
    var totalFileCount = 0;
    function sendFile(file,nowFile) {
        debugger;
        var pash = (Math.random(0, 9999) * 10000) + file.name;
        $.ajax({
            url: 'AjaxUpload.ashx?FileName=' + pash, //server script to process data
            type: 'POST',
            xhr: function () {
                myXhr = $.ajaxSettings.xhr();
                if (myXhr.upload) {
                    myXhr.upload.addEventListener('progress', progressHandlingFunction, false);
                }
                return myXhr;
            },
            success: function (result) {
                $("#progress").append('<img style="margin-right:5px" width="100px" height="150px" src="images/Small_' + pash + '" />')
              
                $("#ProgressComp" + nowFile).remove();
                $("#nameFile" + nowFile).remove();
            },

            data: file,
            cache: false,
            contentType: false,
            processData: false
        });
        function progressHandlingFunction(e) {
            if (e.lengthComputable) {
                var s = parseInt((e.loaded / e.total) * 100);
                $("#progress" + currFile).text(s + "%");
                $("#progbarWidth" + currFile).width(s + "%");
                if (s == 100) {
                    triggerNextFileUpload();
                }
            }
        }
    }

    function triggerNextFileUpload() {
        if (currFile < totalFileCount - 1) {
            currFile = currFile + 1;
            sendFile($("#fileInput")[0].files[currFile], currFile);
        }
        else {
            $("#fileInput").replaceWith($("#fileInput").clone());
        }
    }

    function FileSelected() {
        $("#dvProgess").html('');
        $("#progress").html("");
        totalFileCount = $("#fileInput")[0].files.length;
        for (j = 0; j < totalFileCount; j++) {
            var progControl = $("#dvProgess").append("<div class='liniya progress-striped' id='ProgressComp" + j + "'><div class='Progress'  style='position:absolute' id='progress" + j + "'></div> <div class='bar' id='progbarWidth" + j + "'>&nbsp;</div></div> <div id='nameFile" + j + "' class='liniya nameFile'>" + $("#fileInput")[0].files[j].name + "</div><div class='liniya ovver'></div>");
        }
        uploadFile();
    }

    function uploadFile() {
        currFile = 0;
        sendFile($("#fileInput")[0].files[0], currFile);
    }
</script>

</head>
    <body>
        <form id="form1" runat="server">
            <div id="wrapper" style="width:400px">
                <div>
        <a class="btn btn-mini btn-primary" onclick="document.getElementById('fileInput').click();" role="button" style="margin-right: 16px; width: 59px;">Select File</a>
        <a id="AutoClick" class="btn btn-mini" onclick="javascript:uploadFile();" role="button" style="width: 59px;">Upload Files</a>

        <input id="fileInput" multiple="multiple" onchange="FileSelected();" style="visibility: hidden; width: 1px; height: 1px" type="file" />
                <div id="progress">
                    
                </div>
                <div style="height:1px; width:50%" id="dvProgess">&nbsp;</div>

         </div>
</div>
                      </form>



</body>
</html>
