dotnet
{
    assembly("System.Net.Http")
    {
        //Version = '4.0.0.0';
        //Culture = 'neutral';
        //PublicKeyToken = 'b77a5c561934e089';

        type("System.Net.Http.HttpContent"; "HttpContent")
        {
        }

        type("System.Net.Http.HttpResponseMessage"; "HttpResponseMessage")
        {
        }

        type("System.Net.Http.HttpClient"; "HttpClient")
        {
        }
        type("System.Net.Http.StringContent"; "StringContent")
        {

        }
        type("System.Net.Http.Headers.MediaTypeHeaderValue"; "MediaTypeHeaderValue")
        { }
    }

    assembly("System")
    {
        //Version = '4.0.0.0';
        //Culture = 'neutral';
        //PublicKeyToken = 'b77a5c561934e089';

        type("System.Uri"; "Uri")
        {
        }

        type("System.Net.FtpWebRequest"; "FtpWebRequest")
        {
        }

        type("System.Net.FtpWebResponse"; "FtpWebResponse")
        {
        }

        type("System.Net.NetworkCredential"; "NetworkCredential")
        {
        }

        type("System.Net.FtpStatusCode"; "FtpStatusCode")
        {
        }
        type("System.Net.WebUtility"; "WebUtility")
        {
        }
        type("System.Net.WebResponse"; "WebResponse")
        {

        }


    }


    assembly("mscorlib")
    {
        Version = '4.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';

        type("System.EventArgs"; "EventArgs")
        {
        }

        type("System.IO.Stream"; "Stream")
        {
        }

        type("System.IO.File"; "File")
        {
        }
        type("System.IO.Path"; "Path") { }

        type("System.IO.FileStream"; "FileStream")
        {
        }

        type("System.Collections.ArrayList"; "ArrayList")
        {
        }

        type("System.Object"; "Object")
        {
        }

        type("System.IO.MemoryStream"; "MemoryStream")
        {
        }

        type("System.String"; "String")
        {
        }

        type("System.Array"; "Array")
        {
        }
        type("System.IO.Directory"; "Directory")
        {
        }
        type("System.Text.Encoding"; "Encoding")
        {
        }
        type("System.Text.StringBuilder"; "StringBuilder")
        {
        }

        type("System.IO.StringWriter"; "StringWriter")
        {
        }

        type("System.IO.StringReader"; "StringReader")
        {
        }


    }
    assembly("Newtonsoft.Json")
    {

        type("Newtonsoft.Json.Linq.JObject"; "JObject")
        {
        }

        type("Newtonsoft.Json.JsonTextWriter"; "JsonTextWriter")
        {
        }

        type("Newtonsoft.Json.JsonTextReader"; "JsonTextReader")
        {
        }

        type("Newtonsoft.Json.Formatting"; "Formatting")
        {
        }

        type("Newtonsoft.Json.JsonToken"; "JsonToken")
        {
        }
    }
    assembly("System.Windows.Forms")
    {
        type("System.Windows.Forms.FolderBrowserDialog"; "FolderBrowserDialog") { }
        type("System.Windows.Forms.DialogResult"; "DialogResult") { }
    }
}
