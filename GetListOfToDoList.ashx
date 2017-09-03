<%@ WebHandler Language="C#" Class="GetListOfToDoList" %>

using System;
using System.Web;
using System.Data;
using System.Text;
using DAL;

public class GetListOfToDoList : IHttpHandler
{

    ManageTodoList objMngList = new ManageTodoList();
    clsCommonFuncation objCommonFunction = new clsCommonFuncation();
    StringBuilder stbToDoList = new StringBuilder();

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";

        int intPageIndex = Convert.ToInt32(context.Request.Form["PageIndex"]);
        int intPageSize = Convert.ToInt32(context.Request.Form["PageSize"]);

        string[] strListOfColumn = new string[4];
        strListOfColumn[0] = "";
        strListOfColumn[1] = "TaskText";
        strListOfColumn[2] = "DueDate";
        strListOfColumn[3] = "PriorityId";

        int intColumnIndex = -1;
        if (context.Request.Form["order[0][column]"] != null)
        {
            intColumnIndex = Convert.ToInt32(context.Request.Form["order[0][column]"]);
        }

        string strSortcolumn = "DueDate";
        string strSortOrder = "ASC";
        if (intColumnIndex > 0)
        {
            strSortcolumn = strListOfColumn[intColumnIndex];
            strSortOrder = Convert.ToString(context.Request.Form["order[0][dir]"]);
        }
        
        //Get List of To-Do by due date
        DataTable dtToDoList = null;
        int intTotalTodos = 0;
        dtToDoList = objMngList.GetToDoList(intPageIndex, intPageSize, strSortcolumn, strSortOrder, ref intTotalTodos);

        if (dtToDoList != null)
        {
            if (dtToDoList.Rows.Count > 0)
            {
                stbToDoList.Append("{");
                //stbToDoList.Append("\"" + "draw" + "\":" + "1,");
                stbToDoList.Append("\"" + "recordsTotal" + "\":" + "" + intTotalTodos + ",");
                stbToDoList.Append("\"" + "recordsFiltered" + "\":" + "" + intTotalTodos + ",");

                stbToDoList.Append("\"" + "data" + "\":");
                stbToDoList.Append("[");
                string strDueDate = "";
               
                for (int i = 0; i < dtToDoList.Rows.Count; i++)
                {

                    if (dtToDoList.Rows[i]["DueDate"] != DBNull.Value)
                    {
                        strDueDate = Convert.ToDateTime(dtToDoList.Rows[i]["DueDate"]).ToString("dd/MM/yyyy");
                    }
                    else
                    {
                        strDueDate = "";
                    }
               
                    stbToDoList.Append("[");
                    stbToDoList.Append("\"<input id='hdnid_" + i + "' type='hidden' value='" + Convert.ToString(dtToDoList.Rows[i]["TaskID"]) + "' /><input id='hdnPriorityID_" + i + "' type='hidden' value='" + Convert.ToString(dtToDoList.Rows[i]["PriorityId"]) + "' />\",");
                    stbToDoList.Append("\"" + objCommonFunction.StringTrans_replaceSingleDoubleQuoteToJSONString(Convert.ToString(dtToDoList.Rows[i]["TaskText"])) + "\",");
                    stbToDoList.Append("\"" + objCommonFunction.StringTrans_replaceSingleDoubleQuoteToJSONString(strDueDate) + "\",");
                    stbToDoList.Append("\"<span>" + objCommonFunction.StringTrans_replaceSingleDoubleQuoteToJSONString(Convert.ToString(dtToDoList.Rows[i]["PriorityText"])) + "</span>\"");
                    //stbToDoList.Append("\"<a data-toggle='modal' data-target='#squarespaceModal'><i class='fa fa-pencil'></i></a>\"");

                    if (dtToDoList.Rows.Count - 1 == i)
                    {
                        stbToDoList.Append("]");
                    }
                    else
                    {
                        stbToDoList.Append("],");
                    }
                }

                stbToDoList.Append("]");
                stbToDoList.Append("}");

                context.Response.Write(stbToDoList);

            }
            else
            {
                context.Response.Write(getJsonStringForBlankRecord());
            }

        }
        else
        {
            context.Response.Write(getJsonStringForBlankRecord());
        }
    }

    public StringBuilder getJsonStringForBlankRecord()
    {
        stbToDoList.Append("{");
        stbToDoList.Append("\"" + "recordsTotal" + "\":" + "" + "0" + ",");
        stbToDoList.Append("\"" + "recordsFiltered" + "\":" + "" + "0" + ",");

        stbToDoList.Append("\"" + "data" + "\":[]");
        stbToDoList.Append("}");

        return stbToDoList;
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}