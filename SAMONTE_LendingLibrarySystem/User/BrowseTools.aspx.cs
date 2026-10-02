using System;
using System.Data;
using SAMONTE_LendingLibrarySystem.Helpers;

namespace SAMONTE_LendingLibrarySystem.User
{
    public partial class BrowseTools : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCatalog();
            }
        }

        private void LoadCatalog()
        {
            DataTable dt = DbHelper.ExecuteSPDataTable("sp_GetBrowseCatalog");
            rptCatalog.DataSource = dt;
            rptCatalog.DataBind();
        }
    }
}