<%@ Page Language="C#" AutoEventWireup="true" CodeFile="todolist.aspx.cs" Inherits="todolist" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage To Do list</title>
    <%--Bootstrap Style & Script--%>
    <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="css/dataTables.bootstrap.css" rel="stylesheet" type="text/css" />
    <link href="css/select.dataTables.min.css" rel="stylesheet" type="text/css" />
    <link href="css/jquery.datetimepicker.css" rel="stylesheet" type="text/css" />
    <link href="css/style.css" rel="stylesheet" type="text/css" />
    <%--Jquery Database--%>
    <script type="text/javascript" src="js/jquery-1.12.4.js"></script>
    <script src="js/jquery.dataTables.js" type="text/javascript"></script>
    <script src="js/dataTables.bootstrap.js" type="text/javascript"></script>
    <script src="js/dataTables.select.min.js" type="text/javascript"></script>
    <script src="js/jquery.validate.js" type="text/javascript"></script>    
    <script type="text/javascript" src="js/bootstrap.min.js"></script>
    <script src="js/jquery.datetimepicker.full.min.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">

        $(document).ready(function () {

            //Set Date picker to select due date
            jQuery('#txtDueDate').datetimepicker({
                format: 'd/m/Y',
                timepicker: false
            });

            var todolistTable;
            var pageIndex = 1;
            var pageSize = 10;
            var displayStart = 0;
            UpdateToDoListTable(pageIndex, pageSize, displayStart);

            function UpdateToDoListTable(pageIndex, pageSize, displayStart) {

                todolistTable = $('#todolistTable').DataTable({
                    responsive: true,
                    "filter": false,
                    "iDisplayLength": pageSize,
                    "displayStart": displayStart,
                    "aaSorting": [2, "asc"],
                    "ajax": {
                        "url": "GetListOfToDoList.ashx",
                        "type": "POST",
                        "data": {
                            "PageIndex": pageIndex,
                            "PageSize": pageSize
                        },
                        "dataSrc": function (json) {
                            if (json == "data not found") {
                                return null;
                            }
                            else {
                                return json.data;
                            }
                        }
                    },
                    "processing": true,
                    "serverSide": true,
                    "info": false,
                    "dom": 'rtlp',
                    columnDefs: [{
                        orderable: false,
                        className: 'select-checkbox',
                        targets: 0
                    }],
                    select: {
                        style: 'os',
                        selector: 'td:first-child'
                    }
                });

            }

            //Form validation
            $("form").validate({
                rules: {
                    txtTaskText: "required",
                    txtDueDate: "required",
                    ddlSelectPriority: "required"
                },
                messages: {
                    txtTaskText: "Please enter to-do title",
                    txtDueDate: "Please select due date",
                    ddlSelectPriority: "Please select priority"
                },
                errorClass: "error_msg"
            });

            //trigger this event user deselect any to-do item
            todolistTable.on('deselect', function (e, dt, type, indexes) {
                disableButtons();
            });

            function disableButtons() {
                $("#editToDo").addClass('disabled');
                $("#editToDo").removeAttr('data-toggle');
                $("#editToDo").removeAttr('data-target');

                $("#deleteToDo").addClass('disabled');
                $("#deleteToDo").removeAttr('data-target');

                $("#completedToDo").addClass('disabled');
                $("#completedToDo").removeAttr('data-target');
            }

            //trigger this event user select any to-do item
            todolistTable.on('select', function (e, dt, type, indexes) {
                if (type === 'row') {
                    //var data = table.rows(indexes).data().pluck('id');
                    $("#editToDo").removeClass('disabled');
                    $("#editToDo").attr('data-toggle', 'modal');
                    $("#editToDo").attr('data-target', '#AddEditModal');

                    $("#deleteToDo").removeClass('disabled');
                    $("#deleteToDo").attr('data-toggle', 'modal');
                    $("#deleteToDo").attr('data-target', '#confirm-delete');

                    $("#completedToDo").removeClass('disabled');
                    $("#completedToDo").attr('data-toggle', 'modal');
                    $("#completedToDo").attr('data-target', '#confirm-complete');
                }
            });

            //trigger this click event when user press edit butonn to update selected to-do item
            $("#editToDo").click(function () {
                var data = todolistTable.rows({ selected: true }).data();
                var row_id = todolistTable.row(todolistTable.rows({ selected: true })).index();
                if (data[0] != null) {
                    var taskid = $("#hdnid_" + row_id).val();
                    $("#hdnIsEditMode").val("true");
                    $("#hdnTaskId").val(taskid);
                    var Priorityid = $("#hdnPriorityID_" + row_id).val();
                    $("#txtTaskText").val(data[0][1]);
                    $("#txtDueDate").val(data[0][2]);
                    $("#ddlSelectPriority").val(Priorityid);
                    $("#saveToDo").val("Update");
                    $("#lineModalLabel").text("Edit a to-do");
                }
            });

            $("#addToDo").click(function () {
                $("#txtTaskText").val("");
                $("#txtDueDate").val("");
                $("#ddlSelectPriority").val("");
                $("#saveToDo").val("Save");
                $("#hdnIsEditMode").val("false");
                $("#lineModalLabel").text("Add a to-do");
            });

            //trigger this click event when user wants to delete selected to-do item
            $('#deleteToDoRecord').click(function () {
                var data = todolistTable.rows({ selected: true }).data();
                var row_id = todolistTable.row(todolistTable.rows({ selected: true })).index();
                if (data[0] != null) {
                    var taskid = $("#hdnid_" + row_id).val();
                    DeleteOrMarkedCompletedToDo("delete", taskid);
                }
                else {
                    alert("Please select at least one item.");
                }
                disableButtons();
            });

            //trigger this click event when user wants to mark selected to-do item as completed
            $('#completeToDoRecord').click(function () {
                var data = todolistTable.rows({ selected: true }).data();
                var row_id = todolistTable.row(todolistTable.rows({ selected: true })).index();
                if (data[0] != null) {
                    var taskid = $("#hdnid_" + row_id).val();
                    DeleteOrMarkedCompletedToDo("completed", taskid);
                }
                else {
                    alert("Please select at least one item.");
                }
                disableButtons();
            });

            //function perform to delete/complete to-do item
            function DeleteOrMarkedCompletedToDo(operation, taskId) {
                $.ajax({
                    type: "POST",
                    url: "ajax_call.ashx",
                    data: { Operation: operation, TaskId: taskId },
                    success: function (json) {
                        todolistTable.destroy();
                        UpdateToDoListTable(pageIndex, pageSize, displayStart);
                    }
                });
            }

            $('#todolistTable').on('length.dt', function () {
                UpdateListOnEventsChange();
            });

            $('#todolistTable').on('page.dt', function () {
                UpdateGridOnEventsChange();
            });

            function UpdateGridOnEventsChange() {
                var info = todolistTable.page.info();
                console.log(info);
                var pageIndex = info.page + 1;
                var pageSize = info.length;
                var displayStart = (info.page * info.length)
                todolistTable.destroy();
                UpdateToDoListTable(pageIndex, pageSize, displayStart);
            }

        });

    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div class="main-content">
        <div class="container">
            <div class="slider">
                <div class="row slider-header">
                    <div class="col-lg-10 center-block text-center" style="float: none;">
                        <h2>
                            To-dos
                        </h2>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-8 col-md-8 center-block" style="float: none;">
                    <div class="pull-right">
                        <div class="form-group">
                            <button type="button" id="addToDo" class="btn btn-primary" data-toggle="modal" data-target="#AddEditModal">
                                Add a to-do</button>
                            <button type="button" id="editToDo" class="btn btn-primary disabled">
                                Edit</button>
                            <button type="button" id="deleteToDo" class="btn btn-primary disabled">
                                Delete</button>
                            <button type="button" id="completedToDo" class="btn btn-primary disabled">
                                Completed</button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-8 col-md-8 center-block" style="float: none;">
                    <div class="table-responsive">
                        <table class="table table-striped table-bordered table-hover" id="todolistTable">
                            <thead>
                                <tr>
                                    <th>
                                        &nbsp;
                                    </th>
                                    <th>
                                        Text
                                    </th>
                                    <th>
                                        Due date
                                    </th>
                                    <th>
                                        Priority
                                    </th>
                                    <%--<th>
                                    Actions
                                </th>--%>
                                </tr>
                            </thead>
                        </table>
                    </div>
                </div>
            </div>
            <div class="modal fade" id="AddEditModal" tabindex="-1" role="dialog" aria-labelledby="modalLabel"
                aria-hidden="true">
                <div class="modal-dialog modal-sm">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal">
                                <span aria-hidden="true">×</span><span class="sr-only">Close</span></button>
                            <h3 class="modal-title" id="lineModalLabel">
                                Add a to-do</h3>
                        </div>
                        <div class="modal-body">
                            <!-- content goes here -->
                            <div id="divmsg" runat="server" visible="false">
                            </div>
                            <div class="form-group">
                                <label for="txtTaskText">
                                    Text</label>
                                <input class="form-control" id="txtTaskText" runat="server" name="txtTaskText" placeholder="Enter To-Do task title"
                                    maxlength="100">
                            </div>
                            <div class="form-group">
                                <label for="txtDueDate">
                                    Due Date</label>
                                <input class="form-control" id="txtDueDate" runat="server" name="txtDueDate" placeholder="Select due date">
                            </div>
                            <div class="form-group">
                                <label for="ddlSelectPriority">
                                    Priority</label>
                                <asp:DropDownList ID="ddlSelectPriority" runat="server" class="form-control input-lg"
                                    valuenotequals="0">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <div class="btn-group btn-group-justified" role="group" aria-label="group button">
                                <div class="btn-group" role="group">
                                    <asp:Button runat="server" ID="saveToDo" CssClass="btn btn-primary btn-hover-green"
                                        Text="Save" OnClick="saveToDo_onclick" />
                                </div>
                                <div class="btn-group" role="group">
                                    <button type="button" class="btn btn-default" data-dismiss="modal" role="button">
                                        Close</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="confirm-delete" class="modal fade">
                <div class="modal-dialog modal-sm">
                    <div class="modal-content">
                        <div class="modal-body">
                            Are you sure that you want to delete the selected record?
                        </div>
                        <div class="modal-footer">
                            <button type="button" data-dismiss="modal" class="btn btn-primary" id="deleteToDoRecord">
                                Delete</button>
                            <button type="button" data-dismiss="modal" class="btn">
                                Cancel</button>
                        </div>
                    </div>
                </div>
            </div>
            <div id="confirm-complete" class="modal fade">
                <div class="modal-dialog modal-sm">
                    <div class="modal-content">
                        <div class="modal-body">
                            Are you sure that you want to mark this to-do as completed?
                        </div>
                        <div class="modal-footer">
                            <button type="button" data-dismiss="modal" class="btn btn-primary" id="completeToDoRecord">
                                Completed</button>
                            <button type="button" data-dismiss="modal" class="btn">
                                Cancel</button>
                        </div>
                    </div>
                </div>
            </div>
            <asp:HiddenField ID="hdnIsEditMode" Value="false" runat="server" />
            <asp:HiddenField ID="hdnTaskId" Value="0" runat="server" />
        </div>
    </div>
    </form>
</body>
</html>
