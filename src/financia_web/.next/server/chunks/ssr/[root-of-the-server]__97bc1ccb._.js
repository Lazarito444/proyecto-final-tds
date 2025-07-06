module.exports = {

"[externals]/fs [external] (fs, cjs)": (function(__turbopack_context__) {

var { g: global, __dirname, m: module, e: exports } = __turbopack_context__;
{
const mod = __turbopack_context__.x("fs", () => require("fs"));

module.exports = mod;
}}),
"[externals]/stream [external] (stream, cjs)": (function(__turbopack_context__) {

var { g: global, __dirname, m: module, e: exports } = __turbopack_context__;
{
const mod = __turbopack_context__.x("stream", () => require("stream"));

module.exports = mod;
}}),
"[externals]/zlib [external] (zlib, cjs)": (function(__turbopack_context__) {

var { g: global, __dirname, m: module, e: exports } = __turbopack_context__;
{
const mod = __turbopack_context__.x("zlib", () => require("zlib"));

module.exports = mod;
}}),
"[project]/services/clientFunctions/functions.tsx [app-ssr] (ecmascript)": ((__turbopack_context__) => {
"use strict";

var { g: global, __dirname } = __turbopack_context__;
{
__turbopack_context__.s({
    "goToAlertas": (()=>goToAlertas),
    "goToDashboard": (()=>goToDashboard),
    "goToIndex": (()=>goToIndex),
    "goToLogin": (()=>goToLogin),
    "goToPresupuesto": (()=>goToPresupuesto),
    "goToSignup": (()=>goToSignup),
    "goToTransacciones": (()=>goToTransacciones)
});
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$router$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/node_modules/next/router.js [app-ssr] (ecmascript)");
'use client';
;
const router = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$router$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useRouter"])();
const goToIndex = ()=>{
    router.push('/');
};
const goToLogin = ()=>{
    router.push('/Login');
};
const goToDashboard = ()=>{
    router.push('/Dashboard');
};
const goToTransacciones = ()=>{
    router.push('/Transacciones');
};
const goToSignup = ()=>{
    router.push('/Signup');
};
const goToPresupuesto = ()=>{
    router.push('/Presupuesto');
};
const goToAlertas = ()=>{
    router.push('/Alertas');
};
}}),

};

//# sourceMappingURL=%5Broot-of-the-server%5D__97bc1ccb._.js.map