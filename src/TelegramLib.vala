public errordomain TelegramLibError {
	INVALID_FORMAT
}

public class TelegramLib {

    public const double WAIT_TIMEOUT = 10.0;
    private int client_id = 0;

    private Cupcake cupcake_app = null;

    public TelegramLib(Cupcake cupcake_app) { 
        this.cupcake_app = cupcake_app;

        // We need a client id (aka instance id) to deal with TDLib. 
        client_id = TDJsonApi.create_client_id();

        //  Disable default TDLib log stream
        string setLogResult = TDJsonApi.execute("{\"@type\": \"setLogStream\", \"log_stream\": {\"@type\": \"logStreamEmpty\"}}");
    
        //  Set log callback 
        TDJsonApi.set_log_message_callback(1024, (TDJsonApi.log_message_callback_ptr) log_callback);
    
        //  Set TDLib log verbosity level to 1023 (log everything)
        TDJsonApi.execute("{\"@type\": \"setLogVerbosityLevel\", \"new_verbosity_level\": 1023}");

        TDJsonApi.send(client_id, "{\"@type\": \"getOption\", \"name\": \"version\"}");
    }

    public void begin() {
        Json.Parser json_parser = new Json.Parser();
        while(true) {
            string raw_json = TDJsonApi.receive(WAIT_TIMEOUT);
            if(raw_json == null) { continue; }
            try {
                json_parser.load_from_data(raw_json);
                Json.Node root_node = json_parser.get_root();
                process(root_node);
            } catch (Error e) {
                cupcake_app.update_label_text(e.message);
            }
        }
    }

    private void process(Json.Node response_node) throws TelegramLibError.INVALID_FORMAT {
        if (response_node.get_node_type() != Json.NodeType.OBJECT) {
            throw new TelegramLibError.INVALID_FORMAT("Unexpected element type %s", response_node.type_name());
        }

        unowned Json.Object json_object = response_node.get_object();

        string response_type = json_object.get_string_member("@type");
        switch (response_type) {
            case "updateAuthorizationState":
                Json.Object? authorizaation_state = json_object.get_object_member("authorization_state");
                if(authorizaation_state != null) {
                    handle_update_authorization_state((!) authorizaation_state);
                }
                break;
            default:
                break;
        }
    }

    private void handle_update_authorization_state(Json.Object authorization_state) {
        Json.Node? authorization_type = authorization_state.get_member("@type");

        if(authorization_type == null) { return; }

        switch ((!)authorization_type.get_string()) {
            case "authorizationStateWaitTdlibParameters":
                SetTdLibParameters set_td_lib_parameters = new SetTdLibParameters();
                string set_td_lib_parameters_json = set_td_lib_parameters.to_json();
                TDJsonApi.send(client_id, set_td_lib_parameters_json);
                break;
            default:
                break;
        }
    }

    public static void log_callback(int log_level, string message){
        print("LOG: "+ message + "\n");
    }
}