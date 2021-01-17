#include "include/system_clock/system_clock_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>

#include <cstring>

#define SYSTEM_CLOCK_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), system_clock_plugin_get_type(), \
                              SystemClockPlugin))

struct _SystemClockPlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(SystemClockPlugin, system_clock_plugin, g_object_get_type())

// Called when a method call is received from Flutter.
static void system_clock_plugin_handle_method_call(
    SystemClockPlugin* self,
    FlMethodCall* method_call) {
  g_autoptr(FlMethodResponse) response = nullptr;

  const gchar* method = fl_method_call_get_name(method_call);

  if (strcmp(method, "getPlatformVersion") == 0) {
    struct utsname uname_data = {};
    uname(&uname_data);
    g_autofree gchar *version = g_strdup_printf("Linux %s", uname_data.version);
    g_autoptr(FlValue) result = fl_value_new_string(version);
    response = FL_METHOD_RESPONSE(fl_method_success_response_new(result));
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  fl_method_call_respond(method_call, response, nullptr);
}

static void system_clock_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(system_clock_plugin_parent_class)->dispose(object);
}

static void system_clock_plugin_class_init(SystemClockPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = system_clock_plugin_dispose;
}

static void system_clock_plugin_init(SystemClockPlugin* self) {}

static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                           gpointer user_data) {
  SystemClockPlugin* plugin = SYSTEM_CLOCK_PLUGIN(user_data);
  system_clock_plugin_handle_method_call(plugin, method_call);
}

void system_clock_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  SystemClockPlugin* plugin = SYSTEM_CLOCK_PLUGIN(
      g_object_new(system_clock_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "system_clock",
                            FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}
