using System;
using System.Windows.Forms;
using System.IO;
using System.Xml;

namespace Owasp.VulnReport
{
	/// <summary>
	/// Summary description for VulnReportHelpers.
	/// </summary>
	public class VulnReportHelpers
	{
        private static string strSpecialFile = "DevPath.org";
        private static string strDefaultOrgConfigDirName = "ORG_CONFIG_FILES";

		public VulnReportHelpers()
		{
		}

        public static void loadCustomORGdata()
        {
            string strPathToCustomORGFile = Path.Combine( OrgBasePaths.BasePath ,"CustomORG.xml");
            if (true == File.Exists(strPathToCustomORGFile))
            {
                // main report Xml document
                XmlDocument xdReport = new XmlDocument();
                xdReport.Load(strPathToCustomORGFile);
                XmlElement xeRootNote = xdReport.DocumentElement;
                if (null != xeRootNote)
                {
                    XmlElement xeFindingIdAttributeName = xeRootNote["FindingIdAttributeName"];
                    if (null != xeFindingIdAttributeName)
                        Project.FindingIDAttributeName = xeFindingIdAttributeName.InnerText;
                    //CustomORG    
                }
                
            }
        }
        public static void setBaseDirBasedOnExecutionEnvironment()
        {
            string strFullPathToSpecialFile = Path.GetFullPath(Path.Combine(Environment.CurrentDirectory, strSpecialFile));
            if (true == File.Exists(strFullPathToSpecialFile))      // we are in development mode
                OrgBasePaths.BasePath = Path.Combine(Environment.CurrentDirectory, utils.files.GetFileContents(strFullPathToSpecialFile)); 
            else                                                    // we are in execution mode
                OrgBasePaths.BasePath = Path.Combine(Environment.CurrentDirectory, strDefaultOrgConfigDirName);  
        }

		public static void createNewTargetAndAddItToListBox(ListBox lbTargetListBox, string strNewTargetName, string strFullPathToCurrentProject)
		{
            OrgBasePaths obp = OrgBasePaths.GetPaths();

			if (lbTargetListBox.Items.Contains(strNewTargetName))
			{
				MessageBox.Show("Target already exists, you cannot create a duplicating target!");	
				return;
			}
			int iNumberOfCurrentTargets = lbTargetListBox.Items.Count;

            // We need to remove any periods because it fouls up the loading of the xml files.
            string sanitizedTargetName = strNewTargetName.Replace('.', '_');
            string strFullPathToNewTarget = Path.GetFullPath(Path.Combine(strFullPathToCurrentProject, sanitizedTargetName));
            string strFullPathToNewTargetXmlFile = Path.Combine(strFullPathToNewTarget, sanitizedTargetName) + ".xml";
            if (!Directory.Exists(strFullPathToNewTarget))
            {
                Directory.CreateDirectory(strFullPathToNewTarget);
            }
			
			File.Copy(obp.EmptyProjectFilePath, strFullPathToNewTargetXmlFile);
            lbTargetListBox.Items.Add(sanitizedTargetName);
			lbTargetListBox.SelectedIndex = iNumberOfCurrentTargets;			
		}

		public static void createNewProjectAndAddItToListBox(ListBox lbTargetListBox, string strNewProjectName)
		{
            OrgBasePaths obp = OrgBasePaths.GetPaths();

            UserProfile up = UserProfile.GetUserProfile();
			string strFullPathToNewProject = Path.GetFullPath(Path.Combine(up.ProjectFilesPath, strNewProjectName));							
			Directory.CreateDirectory(strFullPathToNewProject);			
			string strFullPathToNewProjectXmlFile = Path.GetFullPath(Path.Combine(strFullPathToNewProject, strNewProjectName + ".xml"));				
			File.Copy(obp.EmptyProjectFilePath, strFullPathToNewProjectXmlFile);
			lbTargetListBox.Items.Add(strNewProjectName);			
			lbTargetListBox.SelectedIndex = utils.windowsForms.findItemInListBox(lbTargetListBox, strNewProjectName);				
		}

        /// <summary>
        /// Make sure that the following folders and files exist.  If they do not then the
        /// program can not continue to run at least in a useable state.  
        /// 
        /// The following folders and files are required
        /// 
        /// - VulnReport_Files\templates
        ///   - _templateFile_ConsolidatedProjectXmlFile.xml
        ///   - _templateFile_EmptyProjectXmlFile.xml
        /// 
        /// History: 
        /// 11/15/2006 - Mike : Added in the execution of the authentic plugin registration batch file
        ///                     for first time users.  Note there should be a better way to do this.
        /// 1/7/2007 - Mike : Added a cursor so that users would know the program is doing something and not 
        ///                   just sitting there frozen.  Made it so the examples folder was unzipped into the 
        ///                   ORG_BASE_FOLDER area.
        /// </summary>
        public static void confirmExistenceOfRequiredFilesAndFolders()
        {
            // First set the cursor to an hourglass so users know at least something is happening
            System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.WaitCursor;
            try
            {
                //if the org_config_files folder doesn't exist, three zip files need to be unzipped for first time users.            }
                if (!Directory.Exists(OrgBasePaths.BasePath))
                {
                    FileInfo fileconfig = new FileInfo("ORG_CONFIG_FILES.zip.txt");
                    FileInfo fileFOP = new FileInfo("FOP.zip.txt");
                    FileInfo fileAuthenticPlugin = new FileInfo("AuthenticPlugin.zip.txt");
                    fileconfig.CopyTo("ORG_CONFIG_FILES.zip", true);
                    fileFOP.CopyTo("FOP.zip", true);
                    fileAuthenticPlugin.CopyTo("AuthenticPlugin.zip", true);
                    utils.zip.unzipFile(Path.Combine(Environment.CurrentDirectory, "ORG_CONFIG_FILES.zip"),
                                        Environment.CurrentDirectory);
                    utils.zip.unzipFile(Path.Combine(Environment.CurrentDirectory, "FOP.zip"),
                                        Environment.CurrentDirectory);
                    utils.zip.unzipFile(Path.Combine(Environment.CurrentDirectory, "AuthenticPlugin.zip"),
                                        Environment.CurrentDirectory);

                    if (File.Exists(Path.Combine(Environment.CurrentDirectory, "Examples.zip")))
                    {
                        utils.zip.unzipFile(Path.Combine(Environment.CurrentDirectory, "Examples.zip"), 
                                            OrgBasePaths.BasePath);
                    }

                    // Register the Authentic component for first time users
                    if (File.Exists(Path.Combine(Environment.CurrentDirectory, "AuthenticPlugin.dll")) &&
                        File.Exists(Path.Combine(Environment.CurrentDirectory, "regAuthenticPlugin.bat")))
                    {
                        System.Diagnostics.Process.Start(Path.Combine(Environment.CurrentDirectory, "regAuthenticPlugin.bat"));
                    }
                }
            }
            finally
            {
                System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.Default;
            }
            if (!Directory.Exists(Path.Combine(OrgBasePaths.BasePath, "templates"))) 
                throw new Exception("The template folder is missing, please re-install");
            if (!File.Exists(Path.Combine(OrgBasePaths.BasePath, "templates\\_templateFile_EmptyProjectXmlFile.xml")))
                throw new Exception("File: " + OrgBasePaths.BasePath + "templates\\_templateFile_EmptyProjectXmlFile.xml is missing");
            if (!File.Exists(Path.Combine(OrgBasePaths.BasePath, "templates\\_templateFile_ConsolidatedProjectXmlFile.xml")))
                throw new Exception("File: " + OrgBasePaths.BasePath + "templates\\_templateFile_ConsolidatedProjectXmlFile.xml is missing");
        }

        public static void deleteTempFilesAndTerminateProcess()
        {
            deleteTempFiles();
            terminateProcess();
        }

        public static void terminateProcess()
        {
            Environment.Exit(-1);
        }

        public static void deleteTempFiles()
        {
            UserProfile up = UserProfile.GetUserProfile();
            try
            {
                if (Directory.Exists(up.TempDirectoryPath))
                    Directory.Delete(up.TempDirectoryPath, true);
            }
            catch (IOException)
            {
                // Just swallow the exceptions...We are not worried about them
            }
            catch (UnauthorizedAccessException)
            { }
        }
	}
}
