<%@ WebHandler Language="C#" Class="ajax_call" %>

using System;
using System.Web;
using System.Data;
using DAL;

public class ajax_call : IHttpHandler {

    ManageTodoList objMngList = new ManageTodoList();
    clsCommonFuncation objCommonFunction = new clsCommonFuncation();
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";

        string strOperation = Convert.ToString(context.Request.Form["Operation"]);
        int intTaskId = Convert.ToInt32(context.Request.Form["TaskId"]);

        if (strOperation == "delete")
        {
            objMngList.DeleteOrMarkedCompletedToDo("DELETE", intTaskId);
        }
        else if (strOperation == "completed")
        {
            objMngList.DeleteOrMarkedCompletedToDo("COMPLETED", intTaskId);
        }
        
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}