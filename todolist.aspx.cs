using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DAL;
using System.Globalization;

public partial class todolist : System.Web.UI.Page
{
    ManageTodoList objMngList = new ManageTodoList();
    clsCommonFuncation objCommonFunction = new clsCommonFuncation();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindPriorityDropDown();
        }
    }

    public void BindPriorityDropDown()
    {
        ddlSelectPriority.DataTextField = "PriorityText";
        ddlSelectPriority.DataValueField = "id";
        ddlSelectPriority.DataSource = objMngList.GetPriorityList();
        ddlSelectPriority.DataBind();
        ddlSelectPriority.Items.Insert(0, new ListItem("Select Priority", ""));
    }

    protected void saveToDo_onclick(object sender, EventArgs e)
    {
        if (txtTaskText.Value.Trim().Length > 0 && txtDueDate.Value.Trim().Length > 0 && ddlSelectPriority.SelectedIndex > 0)
        {
            divmsg.Visible = false;
            DateTime dtDueDate = DateTime.ParseExact(txtDueDate.Value.Trim(), "dd/MM/yyyy", CultureInfo.InvariantCulture);
            
            if (hdnIsEditMode.Value == "false")
                objMngList.InsertUpdateToDo("INSERT", txtTaskText.Value.Trim(), dtDueDate, Convert.ToInt32(ddlSelectPriority.SelectedValue), 0, 0);
            else if (hdnIsEditMode.Value == "true")
                objMngList.InsertUpdateToDo("UPDATE", txtTaskText.Value.Trim(), dtDueDate, Convert.ToInt32(ddlSelectPriority.SelectedValue), 0, Convert.ToInt32(hdnTaskId.Value));

            string msg = "";
            msg += "<div class=\"alert alert-success fade in\" >";
            msg += "<a href=\"#\" class=\"close\" data-dismiss=\"alert\">&times;</a>";
            msg += "<i class=\"fa fa-check\" aria-hidden=\"true\"></i></div>";

        }
        else
        {
            string msg = "";
            msg += "<div class=\"alert alert-danger fade in\" >";
            msg += "<a href=\"#\" class=\"close\" data-dismiss=\"alert\">&times;</a>";
            msg += "<i class=\"fa fa-exclamation-triangle\" aria-hidden=\"true\"></i>Please fill in all fields!</div>";
            divmsg.InnerHtml = msg;
            divmsg.Visible = true;
        }
    }

}