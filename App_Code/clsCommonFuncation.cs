using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Text;

/// <summary>
/// Summary description for clsCommonFuncation
/// </summary>
/// 

namespace DAL
{
    public class clsCommonFuncation
    {
        /// <summary>
        /// To get total table's row count from DB based on supplied input
        /// </summary>
        /// <param name="strTableName"></param>
        /// <param name="strWhereCondition"></param>
        /// <returns></returns>

        public int GetRowCountByPassingTableNameAndConditions(string strTableName, string strWhereCondition)
        {
            int RowCount = 0;
            SqlConnection objCon = clsConnection.getConnectionString();
            SqlCommand objCmd = null;
            try
            {

                using (objCon)
                {
                    objCon.Open();

                    string strQuery = "";
                    strQuery += "SELECT COUNT(*) FROM " + strTableName;
                    if (strWhereCondition.Length > 0)
                    {
                        strQuery += " WHERE " + strWhereCondition;
                    }

                    objCmd = new SqlCommand();
                    objCmd.Connection = objCon;
                    objCmd.CommandText = strQuery;

                    RowCount = (int)objCmd.ExecuteScalar();

                }
            }
            catch
            {
                throw;
            }
            finally
            {
                if (objCmd != null) objCmd.Dispose();
                if (objCon != null)
                {
                    if (objCon.State == ConnectionState.Open) objCon.Close();
                    objCon.Dispose();
                }
            }

            return RowCount;
        }

        /// <summary>
        ///  Return alternative value if given value is null
        /// </summary>

        public object GetAternativeValueIfValueNull(object value, object alternative)
        {
            try
            {
                if (value.GetType() == typeof(string))
                {
                    if ((string)value == "")
                        return alternative;
                    else
                        return value;
                }
                else
                {
                    if (value == System.DBNull.Value || value == null)
                    {
                        return alternative;
                    }
                    else
                    {
                        return value;
                    }
                }

            }
            catch
            {
                if (value == System.DBNull.Value || value == null)
                {
                    return alternative;
                }
                else
                {
                    return value;
                }
            }
        }

        //vibhav 06/04/2017, replace " quote with \" for json string 
        public string StringTrans_replaceSingleDoubleQuoteToJSONString(string strFieldValue)
        {
            string strUpdatedString = "";
            strUpdatedString = strFieldValue;

            if (strFieldValue.Length > 0 && strFieldValue.Contains("\""))
            {
                strUpdatedString = strFieldValue.Replace(@"""", @"\""");
            }

            return strUpdatedString;
        }

    }
}