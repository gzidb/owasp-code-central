namespace HacmeBank_v2_Website.ascx.admin
{
	using System;
	using System.Data;
	using System.Drawing;
	using System.Web;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;

	/// <summary>
	///		Summary description for Create_Account.
	/// </summary>
	public class Manage_Accounts : System.Web.UI.UserControl
	{
		protected System.Web.UI.WebControls.Label lblErrorMessage;
		protected System.Web.UI.WebControls.Table tblUserDetailsForm;
		protected System.Web.UI.WebControls.TextBox txtAccountNumber;
		protected System.Web.UI.WebControls.DropDownList ddlUserIDs;
		protected System.Web.UI.WebControls.TextBox txtAccountCurrency;
		protected System.Web.UI.WebControls.TextBox txtAccountBranch;
		protected System.Web.UI.WebControls.TextBox txtAccountInitialBalance;
		protected System.Web.UI.WebControls.Button btnCreateNewAccount;
		protected System.Web.UI.WebControls.DropDownList ddlAccountType;

		private void Page_Load(object sender, System.EventArgs e)
		{
			// Put user code to initialize the page here
			fillDropDownBoxWithCurrentUsers();
		}

		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit(e);
		}
		
		/// <summary>
		///		Required method for Designer support - do not modify
		///		the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.btnCreateNewAccount.Click += new System.EventHandler(this.btnCreateNewAccount_Click);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

		private void fillDropDownBoxWithCurrentUsers()
		{
			object[] currentUsers = Global.objUserManagement.WS_ListCurrentUsers("");
			foreach (object currentUser in currentUsers)
			{					
				object[] userDetails = Global.objUserManagement.WS_GetUserDetail_using_userName("",currentUser.ToString());
				string userID = ((decimal)userDetails[0]).ToString();
				string userName = (string)userDetails[1];
				ddlUserIDs.Items.Add(new ListItem(userName + " (acc # " + userID + ")",userID));				
			}
		}

		private void btnCreateNewAccount_Click(object sender, System.EventArgs e)
		{
			Global.objAccountManagement.WS_CreateAccount(	"",
															txtAccountNumber.Text,
															ddlUserIDs.SelectedValue,
															txtAccountCurrency.Text,
															txtAccountBranch.Text,
															txtAccountInitialBalance.Text,
															ddlAccountType.SelectedValue);
											

			lblErrorMessage.Text = "Account #" + txtAccountNumber.Text + " created for user '" + ddlUserIDs.SelectedItem + "'";
		}

	}
}
