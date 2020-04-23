import os
#os.environ["R_LIBS_USER"]=os.environ["HOME"]+"/.R/%V/R_LIBS_USER"
os.environ["PYTHONUSERBASE"]=os.environ["HOME"]+"/.jupyterhub/1.1.0/"
os.environ["JUPYTER_RUNTIME_DIR"]=os.environ["HOME"]+"/.jupyterhub/1.1.0/jupyter/run"
os.environ["JUPYTER_DATA_DIR"]=os.environ["HOME"]+"/.jupyterhub/1.1.0/jupyter/data"
#c.NotebookApp.contents_manager_class = "jupytext.TextFileContentsManager"
c.NotebookApp.contents_manager_class = "jupytext.TextFileContentsManager"
c.ContentsManager.default_jupytext_formats = "ipynb,py"
c.ContentsManager.preferred_jupytext_formats_save = "py:light"
c.ContentsManager.default_cell_markers = "{{{,}}}"
