public class TdLibFunction {
    public string type_function { get; set; }

    public TdLibFunction(string type) {
        this.type_function = type;
    }

    public virtual string to_json() {
        return "";
    }
}