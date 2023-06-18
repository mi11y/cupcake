public class SetTdLibParameters : Object {
    public string database_directory { get; set; }
    public string files_directory { get; set; }
    public string api_id { get; set; }
    public string api_hash { get; set; }
    public string system_language_code { get; set; }
    public string device_model { get; set; }
    public string system_version { get; set; }
    public string application_version { get; set; }
    public bool enable_storage_optimizer { get; set; }
    public bool ignore_file_names { get; set; }
    public bool use_file_database { get; set; }
    public bool use_chat_info_database { get; set; }
    public bool use_message_database { get; set; }
    public bool use_secret_chats { get; set; }
    public bool use_test_dc { get; set; }

    public SetTdLibParameters() {}

    construct {

        use_test_dc = true;
        database_directory = "";
        files_directory = "";
        use_file_database = false;
        use_chat_info_database = false;
        use_message_database = false;
        use_secret_chats = false;
        api_id = "";
        api_hash = "";
        system_language_code = "en_US";
        device_model = "ThinkPad";
        system_version = "";
        application_version = "1.0.0";
        enable_storage_optimizer = true;
        ignore_file_names = true;
   
        string? maybe_api_id = GLib.Environment.get_variable("CUPCAKE_TG_API_ID");
        string? maybe_api_hash = GLib.Environment.get_variable("CUPCAKE_TG_API_HASH");
        if(maybe_api_id != null) {
            this.api_id = (string) maybe_api_id;
        } else {
            print("[WARN][TdLibParameters] CUPCAKE_TG_API_ID Not defined.\n");
        }

        if(maybe_api_hash != null) {
            this.api_hash = (string) maybe_api_hash;
        } else {
            print("[WARN][TdLibParameters] CUPCAKE_TG_API_HASH Not defined.\n");
        }

    }
    
    public string to_json() {
        Json.Object main_object = new Json.Object();
        main_object.set_string_member("@type", "setTdlibParameters");
        main_object.set_string_member("database_directory", database_directory);
        main_object.set_string_member("files_directory", files_directory);
        main_object.set_string_member( "api_id", api_id);
        main_object.set_string_member("api_hash", api_hash);
        main_object.set_string_member("system_language_code", system_language_code);
        main_object.set_string_member("device_model", device_model);
        main_object.set_string_member("system_version", system_version);
        main_object.set_string_member("application_version", application_version);

        main_object.set_boolean_member("enable_storage_optimizer", enable_storage_optimizer);
        main_object.set_boolean_member("ignore_file_names", ignore_file_names);
        main_object.set_boolean_member("use_file_database", use_file_database);
        main_object.set_boolean_member("use_chat_info_database", use_chat_info_database);
        main_object.set_boolean_member("use_message_database", use_message_database);
        main_object.set_boolean_member("use_secret_chats", use_secret_chats);
        main_object.set_boolean_member("use_test_dc", use_test_dc);

        Json.Node wrapper = new Json.Node(Json.NodeType.OBJECT);
        wrapper.set_object(main_object);

        Json.Generator generator = new Json.Generator();
        generator.set_root(wrapper);

        return generator.to_data(null);
    }
}