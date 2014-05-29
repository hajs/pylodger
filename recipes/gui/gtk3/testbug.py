"""
Traceback (most recent call last):
  File "test.py", line 1, in <module>
    from gi.repository import Gtk
  File "/localhome/henning/pydist/lib/python2.7/site-packages/gi/importer.py", line 68, in load_module
    dynamic_module._load()
  File "/localhome/henning/pydist/lib/python2.7/site-packages/gi/module.py", line 294, in _load
    self._introspection_module = get_introspection_module(self._namespace)
  File "/localhome/henning/pydist/lib/python2.7/site-packages/gi/module.py", line 273, in get_introspection_module
    module = IntrospectionModule(namespace, version)
  File "/localhome/henning/pydist/lib/python2.7/site-packages/gi/module.py", line 122, in __init__
    repository.require(namespace, version)
gi.RepositoryError: Typelib file for namespace 'GdkPixbuf', version '2.0' not found

"""
from gi.repository import Gtk

win = Gtk.Window()
win.connect("delete-event", Gtk.main_quit)
win.show_all()
Gtk.main()
