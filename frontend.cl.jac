cl import ".styles.global.css";

cl def:pub app() -> JsxElement {
    has count: int = 0;

    return <div className="w-full min-h-screen flex flex-col items-center justify-center text-center p-8">
        <div className="flex items-center justify-center gap-10 mb-8">
            <a href="https://vite.dev" target="_blank">
                <img
                    src="/static/assets/vite_logo.png"
                    className="w-24 h-24 object-contain transition-[filter] duration-300 logo-vite"
                    alt="Vite logo"
                />
            </a>
            <a href="https://jaseci.org" target="_blank">
                <img
                    src="/static/assets/jaseci_logo.png"
                    className="w-24 h-24 object-contain transition-[filter] duration-300 logo-jaseci"
                    alt="Jaseci logo"
                />
            </a>
        </div>

        <h1 className="text-5xl font-bold leading-tight mb-8 gradient-text">Vite + Jac</h1>

        <div className="p-8 rounded-xl bg-white/5 border border-white/10 mb-6">
            <button
                className="font-[inherit] text-base font-medium px-6 py-2.5 rounded-lg border border-transparent bg-[#1a1a1a] text-white/90 cursor-pointer transition-[border-color,background-color] duration-[250ms] hover:border-purple-500 hover:bg-[#2a2a2a]"
                onClick={lambda -> None { count = count + 1; }}
            >
                {"count is " + (count.toString())}
            </button>
            <p className="mt-3 text-sm text-white/50">
                Edit <code className="font-mono bg-white/10 px-1.5 py-0.5 rounded text-[0.8rem]">main.jac</code> and save to test HMR
            </p>
        </div>

        <p className="mt-6 text-white/35 text-xs">
            Click on the Vite and Jaseci logos to learn more
        </p>
    </div>;
}
