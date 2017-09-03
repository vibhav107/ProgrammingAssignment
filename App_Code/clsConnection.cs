using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;

namespace DAL
{
    public class clsConnection
    {
        public static string strConn;

        /// This function is used to set the connection string
        public static SqlConnection getConnectionString()
        {
            string strServerName = System.Configuration.ConfigurationManager.AppSettings.Get("dbservername");
            string strUserName = System.Configuration.ConfigurationManager.AppSettings.Get("dbusername");
            string strPassword = System.Configuration.ConfigurationManager.AppSettings.Get("dbpassword");
            string strDB = System.Configuration.ConfigurationManager.AppSettings.Get("dbName");
            strConn = "Data Source=" + strServerName + ";Initial Catalog=" + strDB + ";User Id=" + strUserName + ";Password=" + strPassword;
            SqlConnection con = new SqlConnection(strConn);
            return con;
        }
    }
}