using System;
using System.Data;
using SAMONTE_LendingLibrarySystem.Helpers;

namespace SAMONTE_LendingLibrarySystem.Admin
{
    public partial class ReturnedItems : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadReturnedItems();
            }
        }

        private void LoadReturnedItems()
        {
            DataTable dt = DbHelper.ExecuteSPDataTable("sp_GetReturnedItems");
            gvReturnedItems.DataSource = dt;
            gvReturnedItems.DataBind();
        }
    }
}