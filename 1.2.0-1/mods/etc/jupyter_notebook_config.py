import os
#os.environ["R_LIBS_USER"]=os.environ["HOME"]+"/.R/%V/R_LIBS_USER"
if not os.path.isdir(os.environ["HOME"]+"/.jupyterhub/python/"):
    os.makedirs(os.environ["HOME"]+"/.jupyterhub/python/")
os.environ["PYTHONUSERBASE"]=os.environ["HOME"]+"/.jupyterhub/python/"
os.environ["JUPYTER_RUNTIME_DIR"]=os.environ["HOME"]+"/.jupyterhub/python/jupyter/run"
os.environ["JUPYTER_DATA_DIR"]=os.environ["HOME"]+"/.jupyterhub/python/jupyter/data"
#c.NotebookApp.contents_manager_class = "jupytext.TextFileContentsManager"
c.NotebookApp.contents_manager_class = "jupytext.TextFileContentsManager"
c.ContentsManager.default_jupytext_formats = "ipynb,py"
c.ContentsManager.preferred_jupytext_formats_save = "py:light"
c.ContentsManager.default_cell_markers = "{{{,}}}"

# https://github.com/jupyter/notebook/pull/2963
c.MappingKernelManager.cull_idle_timeout = 172800
c.NotebookApp.shutdown_no_activity_timeout = 600
