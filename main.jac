include server;

cl import ".styles.global.css";
cl import from .frontend { app as ClientApp }

cl {
    def:pub app() -> JsxElement {
        return <ClientApp />;
    }
}