public class TelegramLib {

    public const double WAIT_TIMEOUT = 10.0;

    private Cupcake cupcake_app = null;

    public TelegramLib(Cupcake cupcake_app) { 
        this.cupcake_app = cupcake_app;
    }

    public static void log_callback(int log_level, string message){
        print("LOG: "+ message + "\n");
    }

    public void begin() {
        // We need a client id (aka instance id) to deal with TDLib. 
        int client_id = TDJsonApi.create_client_id();

        //  Disable default TDLib log stream
        string setLogResult = TDJsonApi.execute("{\"@type\": \"setLogStream\", \"log_stream\": {\"@type\": \"logStreamEmpty\"}}");
    
        //  Set log callback 
        TDJsonApi.set_log_message_callback(1024, (TDJsonApi.log_message_callback_ptr) log_callback);
    
        //  Set TDLib log verbosity level to 1023 (log everything)
        TDJsonApi.execute("{\"@type\": \"setLogVerbosityLevel\", \"new_verbosity_level\": 1023}");
        
        TDJsonApi.send(client_id, "{\"@type\": \"getOption\", \"name\": \"version\"}");

        
        while(true) {
            string received_result = TDJsonApi.receive(WAIT_TIMEOUT);
            print("Received_result: %s\n", received_result);
            if(received_result != null) {
                cupcake_app.updateLabelText(received_result);
            }
        }
    }
}