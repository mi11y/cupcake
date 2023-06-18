public class AuthorizationState : Object {

    private int client_id { get; set; }

    // Signals
    public signal void waiting_for_a_response ();
    public signal void finished_waiting ();

    public AuthorizationState(int client_id) {
        this.client_id = client_id;
    }

    public void handle_update_authorization_state(Json.Object json_object) {

        Json.Object? authorizaation_state = json_object.get_object_member("authorization_state");
        if(authorizaation_state != null) {
            process_authorization_state((!) authorizaation_state);
        }

    }

    private void process_authorization_state(Json.Object authorization_state) {
        Json.Node? authorization_type = authorization_state.get_member("@type");
        if(authorization_type == null) { return; }

        switch ((!)authorization_type.get_string()) {
            case "authorizationStateWaitTdlibParameters":
                SetTdLibParameters set_td_lib_parameters = new SetTdLibParameters();
                string set_td_lib_parameters_json = set_td_lib_parameters.to_json();
                TDJsonApi.send(client_id, set_td_lib_parameters_json);
                begin_waiting ();
                break;
            case "authorizationStateWaitPhoneNumber":
                done_waiting ();
                break;
            default:
                break;
        }
    }

    private void begin_waiting () {
        waiting_for_a_response ();
    }

    private void done_waiting () {
        finished_waiting ();
    }
}