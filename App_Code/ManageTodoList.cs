using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Text;

/// <summary>
/// Summary description for ManageTodoList
/// </summary>
/// 
namespace DAL
{
    public class ManageTodoList
    {
        public DataTable GetToDoList(int intPageindex, int intPageSize, string strSortColumn, string strSortBy, ref int intRecordCount)
        {
            DataTable dtTodoList = null;
           
            SqlConnection objCon = clsConnection.getConnectionString();
            SqlCommand objCmd = new SqlCommand();

            try
            {
                using (objCon)
                {
                    objCon.Open();
                    objCmd.Connection = objCon;
                    objCmd.CommandType = System.Data.CommandType.StoredProcedure;
                    objCmd.CommandText = "GetToDoList";
                    objCmd.Parameters.Add("@PageIndex", SqlDbType.Int).Value = intPageindex;
                    objCmd.Parameters.Add("@PageSize", SqlDbType.Int).Value = intPageSize;
                    objCmd.Parameters.Add("@sortColumn", SqlDbType.VarChar).Value = strSortColumn;
                    objCmd.Parameters.Add("@sortOrder", SqlDbType.VarChar).Value = strSortBy;
                    objCmd.Parameters.Add("@RecordCount", SqlDbType.Int);
                    objCmd.Parameters["@RecordCount"].Direction = ParameterDirection.Output;

                    SqlDataAdapter da = new SqlDataAdapter(objCmd);
                    dtTodoList = new DataTable();
                    da.Fill(dtTodoList);

                    intRecordCount = Convert.ToInt32(objCmd.Parameters["@RecordCount"].Value);

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

            return dtTodoList;

        }

        public DataTable GetPriorityList()
        {
            DataTable dtPriorityList = null;

            SqlConnection objCon = clsConnection.getConnectionString();
            SqlCommand objCmd = new SqlCommand();

            try
            {
                using (objCon)
                {
                    objCon.Open();
                    objCmd.Connection = objCon;
                    objCmd.CommandType = System.Data.CommandType.StoredProcedure;
                    objCmd.CommandText = "GetPriorityList";
                    
                    SqlDataAdapter da = new SqlDataAdapter(objCmd);
                    dtPriorityList = new DataTable();
                    da.Fill(dtPriorityList);

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

            return dtPriorityList;
        }

        public void InsertUpdateToDo(string Operation, string TaskText, DateTime DueDate, int PriorityId, int IsCompleted, int TaskID)
        {
            SqlConnection objCon = clsConnection.getConnectionString();
            SqlCommand objCmd = new SqlCommand();

            try
            {
                using (objCon)
                {
                    objCon.Open();
                    objCmd.Connection = objCon;
                    objCmd.CommandType = System.Data.CommandType.StoredProcedure;
                    objCmd.CommandText = "InsertUpdateToDo";
                    objCmd.Parameters.Add("@Operation", SqlDbType.VarChar).Value = Operation;
                    objCmd.Parameters.Add("@TaskText", SqlDbType.NVarChar).Value = TaskText;
                    objCmd.Parameters.Add("@DueDate", SqlDbType.Date).Value = DueDate;
                    objCmd.Parameters.Add("@PriorityId", SqlDbType.Int).Value = PriorityId;
                    objCmd.Parameters.Add("@IsCompleted", SqlDbType.Bit).Value = IsCompleted;
                    objCmd.Parameters.Add("@TaskID", SqlDbType.Int).Value = TaskID;
                    
                    objCmd.ExecuteNonQuery();
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

        }

        public void DeleteOrMarkedCompletedToDo(string Operation, int TaskID)
        {
            SqlConnection objCon = clsConnection.getConnectionString();
            SqlCommand objCmd = new SqlCommand();

            try
            {
                using (objCon)
                {
                    objCon.Open();
                    objCmd.Connection = objCon;
                    objCmd.CommandType = System.Data.CommandType.StoredProcedure;
                    objCmd.CommandText = "DeleteOrMarkedCompletedToDo";
                    objCmd.Parameters.Add("@Operation", SqlDbType.VarChar).Value = Operation;
                    objCmd.Parameters.Add("@TaskID", SqlDbType.Int).Value = TaskID;

                    objCmd.ExecuteNonQuery();
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

        }

    }
}