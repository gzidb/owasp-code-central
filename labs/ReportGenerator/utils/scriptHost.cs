using System;
using System.Windows.Forms;
using System.Runtime.Remoting;
using System.Runtime.InteropServices;
using System.Runtime.Serialization;
using System.IO;
using System.CodeDom;
using System.Configuration;
using System.Reflection;
using System.CodeDom.Compiler;
using System.Resources;

namespace Owasp.VulnReport.utils
{
	/// <summary>
	/// Summary description for scriptHost.
	/// </summary>
	public class scriptHost
	{

		// Large parts of this code were based on http://www.thecodeproject.com/dotnet/nscript.asp
		public scriptHost()
		{
		}

        public static CompilerResults compileAndReturnCompilerResults(string strSourceCodeToExecute, string[] strReferenceAssembliesToAdd, ref string strCompilationErrors)
        {
            string strTempFileName = Path.GetTempFileName();
            if (strSourceCodeToExecute.Length == 0)
            {
                MessageBox.Show("Code to compile cannot be empty");
                return null;
            }
            else
            {
                utils.files.SaveFileWithStringContents(strTempFileName, strSourceCodeToExecute);
                WindowsApp  waWindowsApp = new WindowsApp();
                CompilerResults crCompilerResults = waWindowsApp.compileAndReturnCompilerResultsObject(strTempFileName, strReferenceAssembliesToAdd);
                strCompilationErrors = waWindowsApp.StrCompilationErrors;
                return crCompilerResults;
            }
        }

		public static void compileAndExecuteSourceCode(string strSourceCodeToExecute, string strArguments,string[] strReferenceAssembliesToAdd)
		{
			string strTempFileName = Path.GetTempFileName();
			if (strSourceCodeToExecute.Length==0)			
				MessageBox.Show("Code to compile cannot be empty");			
			else
			{				
				utils.files.SaveFileWithStringContents(strTempFileName,strSourceCodeToExecute);
				new WindowsApp().Run(new string[] {strTempFileName,strArguments}, strReferenceAssembliesToAdd);
			}
		}


		public static string compileSourceCode(string strSourceCodeToExecute,string[] strReferenceAssembliesToAdd, string strPathToTempCompiledFile)
		{            			
            if ("" == strPathToTempCompiledFile)
                strPathToTempCompiledFile = Path.GetTempFileName();
            else
                strPathToTempCompiledFile = Path.Combine(strPathToTempCompiledFile, files.returnUniqueFileName(".tmp.cs"));
			if (strSourceCodeToExecute.Length==0)			
				return "Error: Code to compile cannot be empty";			
			else
			{                
                utils.files.SaveFileWithStringContents(strPathToTempCompiledFile, strSourceCodeToExecute);
                string strCompilationResult = new WindowsApp().Compile(strPathToTempCompiledFile, strReferenceAssembliesToAdd);
                if ("" == strCompilationResult)
                {
                    File.Delete(strPathToTempCompiledFile);
                    return "Compilation OK";
                }
                else
                    return strCompilationResult;
			}            
		}

		public static string compileAndExecuteFile(string strFileToExecute,string[] strReferenceAssembliesToAdd)
		{
			WindowsApp waWindowsApp = new WindowsApp();
            waWindowsApp.Run(new string[] { strFileToExecute }, strReferenceAssembliesToAdd);
            return waWindowsApp.StrCompilationErrors;
		}	

		public interface IScriptManager
		{
			void CompileAndExecuteFile(string file, string[] args, string[] strReferenceAssembliesToAdd, IScriptManagerCallback callback);
            System.CodeDom.Compiler.CompilerResults CompileFile(string file, string[] strReferenceAssembliesToAdd, IScriptManagerCallback callback);
		}

		public interface IScriptManagerCallback
		{
			void OnCompilerError(CompilerError[] errors);
		}


		[Serializable]
			public class CompilerError
		{
			private int line;
			private string file;
			private int column;
			private string text;
			private string number;
			public int Line
			{
				get
				{
					return line;
				}
				set
				{
					line = value;
				}
			}

			public string File
			{
				get
				{
					return file;
				}
				set
				{
					file = value;
				}
			}

			public int Column
			{
				get
				{
					return column;
				}
				set
				{
					column = value;
				}
			}

			public string Text
			{
				get
				{
					return text;
				}
				set
				{
					text = value;
				}
			}

			public string Number
			{
				get
				{
					return number;
				}
				set
				{
					number = value;
				}
			}

			public CompilerError()
			{
			}
	
			public CompilerError(System.CodeDom.Compiler.CompilerError error)
			{
				this.column = error.Column;
				this.file = error.FileName;
				this.line = error.Line;
				this.number = error.ErrorNumber;
				this.text = error.ErrorText;
			}
		}

		public abstract class BaseApp : MarshalByRefObject, IScriptManagerCallback
		{
			private AppDomain executionDomain;
			private string fileName;
            private string strCompilationErrors = "";

			public BaseApp()
			{
			}
		
			#region Overridables for derived classes
			protected void TerminateExecution()
			{
				AppDomain.Unload(executionDomain);
			}
		
			protected abstract void ExecutionLoop(IAsyncResult result);
			protected abstract void TerminateExecutionLoop();
			protected abstract void ShowErrorMessage(string message);

			#endregion

			#region Utility function for derived classes		
			protected string FileName
			{
				get
				{
					return this.fileName;
				}
			}

			protected string EntryAssemblyName
			{
				get
				{
					return Path.GetFileNameWithoutExtension(Assembly.GetEntryAssembly().Location);
				}
			}

			protected void ShowErrorMessage(string message, params object[] args)
			{
				ShowErrorMessage(String.Format(message, args));
			}
/*
			protected void ShowErrorMessageFromResource(string id, params object[] args)
			{
				ShowErrorMessage(resMgr.GetString(id), args);
			}
		
			protected static string GetResourceString(string name)
			{
				return resMgr.GetString(name);
			}

			protected static object GetResourceObject(string name)
			{
				return resMgr.GetObject(name);
			}
			*/
			#endregion

			#region Other Utility Methods
			private void ShowUsage()
			{
				//ShowErrorMessageFromResource("Usage", EntryAssemblyName);
				ShowErrorMessage("Usage error (from resource):" + EntryAssemblyName);
			}
			#endregion
		
			delegate void CompileAndExecuteRoutine(string file, string[] args, string[] strReferenceAssembliesToAdd, IScriptManagerCallback callback);

            delegate void compileAndReturnCompilerResults(string file, string[] strReferenceAssembliesToAdd, IScriptManagerCallback callback);

			public string Compile(string strfile, string[] strReferenceAssembliesToAdd)
			{
				string strErrorMsg = "";
				System.CodeDom.Compiler.CompilerResults crResults = new ScriptManager().CompileSourceCode(strfile,strReferenceAssembliesToAdd);

				if (crResults.Errors.HasErrors)
				{
					System.Collections.ArrayList templist = new System.Collections.ArrayList();

					foreach(System.CodeDom.Compiler.CompilerError error in crResults.Errors)
					{
						strErrorMsg += error.ToString() + Environment.NewLine;
					}					
				}
				return strErrorMsg;
			}

            public System.CodeDom.Compiler.CompilerResults compileAndReturnCompilerResultsObject(string file, string[] strReferenceAssembliesToAdd)
            {
                try
                {
                    //Create an AppDomain to compile and execute the code
                    //This enables us to cancel the execution if needed
                    //executionDomain = AppDomain.CreateDomain("ExecutionDomain");
                    //IScriptManager manager = (IScriptManager)executionDomain.CreateInstanceFromAndUnwrap(typeof(BaseApp).Assembly.Location, typeof(ScriptManager).FullName);
                    ScriptManager smScriptManager = new ScriptManager();
                    System.CodeDom.Compiler.CompilerResults scCompilerResults = smScriptManager.CompileFile(file, strReferenceAssembliesToAdd, this);
                    return scCompilerResults;
                }
                catch (UnsupportedLanguageExecption e)
                {
                    ShowErrorMessage("UnsupportedLanguage (from resource):" + e.Extension);
                }
                catch (AppDomainUnloadedException e)
                {
                    System.Diagnostics.Trace.WriteLine(e.Message);
                }
                catch (Exception e)
                {
                    ShowErrorMessage(e.Message);
                }

                TerminateExecutionLoop();
                return null;
            }

			private void CompileAndExecute(string file, string[] args,string[] strReferenceAssembliesToAdd, IScriptManagerCallback callback)
			{
				try
				{
					//Create an AppDomain to compile and execute the code
					//This enables us to cancel the execution if needed
					executionDomain = AppDomain.CreateDomain("ExecutionDomain");					
					IScriptManager manager = (IScriptManager)executionDomain.CreateInstanceFromAndUnwrap(typeof(BaseApp).Assembly.Location, typeof(ScriptManager).FullName); 					

					manager.CompileAndExecuteFile(file, args, strReferenceAssembliesToAdd, this);
				}
				catch(UnsupportedLanguageExecption e)
				{
					ShowErrorMessage("UnsupportedLanguage (from resource):" + e.Extension);
				}
				catch(AppDomainUnloadedException e)
				{
					System.Diagnostics.Trace.WriteLine(e.Message);
				}
				catch(Exception e)
				{
					ShowErrorMessage(e.Message);
				}
			
				TerminateExecutionLoop();
			}			            



			public void Run(string[] args,string[] strReferenceAssembliesToAdd)
			{
				if (args.Length < 1)
				{
					ShowUsage();
					return;
				}
			
				fileName = args[0];

				if (!File.Exists(fileName))
				{
					ShowErrorMessage("FileDoesnotExist (from resource):" + args[0]);
					return;
				}
		
				//Create new argument array removing the file name
				string[] newargs = new String[args.Length - 1];
				Array.Copy(args, 1, newargs, 0, args.Length - 1);
			
				CompileAndExecuteRoutine asyncDelegate = new CompileAndExecuteRoutine(this.CompileAndExecute);
				IAsyncResult result = asyncDelegate.BeginInvoke(fileName, newargs, strReferenceAssembliesToAdd, this, null, null);
			}

			#region Implementation of IScriptManagerCallback
			public void OnCompilerError(CompilerError[] errors)
			{
				StringWriter writer = new StringWriter();
				
				string errorFormat = "ScriptHostCompiler Error: \n\n{0}({3}, {4}) : Error {1} - {2}";//  BaseApp.GetResourceString("CompilerErrorFormat");
				
				foreach(CompilerError error in errors)
				{
					writer.WriteLine(errorFormat, error.File, error.Number, error.Text, error.Line, error.Column);				
				}
				
				//throw new ApplicationException(writer.ToString());            // We can't crash the app in these cases, we should just show a message to the user with the error that occured
                // For now do it via Messagebox, but ideally the should go to txtDebugMessages Text Box
                //MessageBox.Show(writer.ToString());

                // Errors are now placed on strCompilationErrors so it is the caller's responsibility to check them
                strCompilationErrors = writer.ToString();
			}

            public string StrCompilationErrors
            {
                get 
                {
                    return strCompilationErrors;
                }
            }
			#endregion
		}

		public class ScriptManager : MarshalByRefObject, IScriptManager
		{
			public ScriptManager()
			{
			}
		
			private void AddReferencesFromFile(CompilerParameters compilerParams, string nrfFile)
			{
				using(StreamReader reader = new StreamReader(nrfFile))
				{
					string line;;
                    while ((line = reader.ReadLine()) != null)
                    {
                        compilerParams.ReferencedAssemblies.Add(line);
                    }
				}
			}

			#region Implementation of IScriptManager
			public void CompileAndExecuteFile(string file, string[] args, string[] strReferenceAssembliesToAdd, IScriptManagerCallback callback)
			{
				System.CodeDom.Compiler.CompilerResults crResults = CompileSourceCode(file,strReferenceAssembliesToAdd);
				if (crResults.Errors.HasErrors)
				{
					System.Collections.ArrayList templist = new System.Collections.ArrayList();
					foreach(System.CodeDom.Compiler.CompilerError error in crResults.Errors)
					{
						templist.Add(new CompilerError(error));
					}
					callback.OnCompilerError((CompilerError[])templist.ToArray(typeof(CompilerError)));
				}
				else
				{
					crResults.CompiledAssembly.EntryPoint.Invoke(null, BindingFlags.Static, null, new object[]{args}, null);                   
				}
			}

            public System.CodeDom.Compiler.CompilerResults CompileFile(string file, string[] strReferenceAssembliesToAdd, IScriptManagerCallback callback)
            {
                System.CodeDom.Compiler.CompilerResults crResults = CompileSourceCode(file, strReferenceAssembliesToAdd);
                if (crResults.Errors.HasErrors)
                {
                    System.Collections.ArrayList templist = new System.Collections.ArrayList();
                    foreach (System.CodeDom.Compiler.CompilerError error in crResults.Errors)
                    {
                        templist.Add(new CompilerError(error));
                    }
                    callback.OnCompilerError((CompilerError[])templist.ToArray(typeof(CompilerError)));
                    return null;
                }
                else
                {
                    return crResults;                    
                }
            }

            public void executeCode(System.CodeDom.Compiler.CompilerResults crResults, string[] args)
            {
                crResults.CompiledAssembly.EntryPoint.Invoke(null, BindingFlags.Static, null, new object[] { args }, null);
                Type[] tTypes = crResults.CompiledAssembly.GetTypes();
                foreach (Type tType in tTypes)
                    foreach (MethodInfo mi in tType.GetMethods())
                        Console.WriteLine(tType.FullName + "." + mi.Name);
                //return crResults;
            }

            /// <summary>
            /// This method compiles the source given to it dynamically for use in plugins, etc...
            /// 
            /// --== History of Changes ==--
            /// 11/05/2006 - Mike : Removed the compiler variable and called the provider method
            ///                     CompilerAssemblyFromFile directly.  I did this to remove a warning.
            /// </summary>
            /// <param name="strFile">The file we wish to compile</param>
            /// <param name="strReferenceAssembliesToAdd">Assemblies that need to be included in the compile</param>
            /// <returns>The results of the compile</returns>
			public System.CodeDom.Compiler.CompilerResults CompileSourceCode(string strFile,string[] strReferenceAssembliesToAdd)	// [DC]
			{
				//Currently only csharp scripting is supported
				CodeDomProvider provider;
				string extension = Path.GetExtension(strFile);

				switch(extension)
				{
					case ".tmp":		// default tmp files to .cs
					case ".cs":
					case ".ncs":
						provider = new Microsoft.CSharp.CSharpCodeProvider();
						break;
					case ".vb":
					case ".nvb":
						provider = new Microsoft.VisualBasic.VBCodeProvider();
						break;
					case ".njs":
					case ".js":
						provider = (CodeDomProvider)Activator.CreateInstance("Microsoft.JScript", "Microsoft.JScript.JScriptCodeProvider").Unwrap();
						break;
					default:
						throw new UnsupportedLanguageExecption(extension);
				}
				System.CodeDom.Compiler.CompilerParameters compilerparams = new System.CodeDom.Compiler.CompilerParameters();
				compilerparams.GenerateInMemory = true;
				compilerparams.GenerateExecutable = true;
			
				// manually add references (since he nfr bellow system will need to be implemented a diferent way)
				compilerparams.ReferencedAssemblies.Add("System.dll");
				compilerparams.ReferencedAssemblies.Add("System.Windows.Forms.Dll");
                foreach (string strReferenceAssemblyToAdd in strReferenceAssembliesToAdd)                
                    compilerparams.ReferencedAssemblies.Add(strReferenceAssemblyToAdd);                
                // we don't use this (since the extra references are retrieved from the Xml file
                /*
				//Add assembly references from nscript.nrf or <file>.nrf
				string nrfFile = Path.ChangeExtension(strFile, "nrf");

				if (File.Exists(nrfFile))
					AddReferencesFromFile(compilerparams, nrfFile);
				else
				{
					//Use nscript.nrf
					nrfFile = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), "nscript.nrf");

					if (File.Exists(nrfFile))
						AddReferencesFromFile(compilerparams, nrfFile);
				}
                 * */
				System.CodeDom.Compiler.CompilerResults crResults = provider.CompileAssemblyFromFile(compilerparams, strFile);

				return crResults;
			}
			#endregion
		}

		[Serializable]
			public class UnsupportedLanguageExecption : Exception, ISerializable
		{
			private string extension;
		
			public UnsupportedLanguageExecption(SerializationInfo info, StreamingContext ctxt)
				: base(info, ctxt)
			{
				extension = info.GetString("extension");
			}

			public UnsupportedLanguageExecption(string extension)
			{
				this.extension = extension;
			}
	
			public string Extension
			{
				get
				{
					return extension;
				}
				set
				{
					extension = value;
				}
			}

			#region Implementation of ISerializable
			public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context)
			{
				base.GetObjectData(info, context);
				info.AddValue("extension", extension);
			}
			#endregion

		}

		public class WindowsApp : BaseApp
		{
			public WindowsApp()
			{
			}

			protected override void ShowErrorMessage(string message)
			{
				MessageBox.Show(message, EntryAssemblyName, MessageBoxButtons.OK, MessageBoxIcon.Error);
			}

			protected override void ExecutionLoop(System.IAsyncResult result)
			{

			}

			protected override void TerminateExecutionLoop()
			{
			}
		
			private void OnIconDoubleClick(object sender, EventArgs e)
			{
				if (MessageBox.Show(String.Format("Cancel Execution?", ""), EntryAssemblyName, MessageBoxButtons.YesNo) == DialogResult.Yes)
				{
					TerminateExecution();
				}
			}
		}

	}
}
