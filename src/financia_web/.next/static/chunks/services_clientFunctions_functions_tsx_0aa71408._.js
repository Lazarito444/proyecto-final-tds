(globalThis.TURBOPACK = globalThis.TURBOPACK || []).push([typeof document === "object" ? document.currentScript : undefined, {

"[project]/services/clientFunctions/functions.tsx [app-client] (ecmascript)": ((__turbopack_context__) => {
"use strict";

var { g: global, __dirname, k: __turbopack_refresh__, m: module } = __turbopack_context__;
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
'use client';
const goToIndex = (router)=>{
    router.push('/');
};
const goToLogin = (router)=>{
    router.push('/Login');
};
const goToDashboard = (router)=>{
    router.push('/Dashboard');
};
const goToTransacciones = (router)=>{
    router.push('/Transacciones');
};
const goToSignup = (router)=>{
    router.push('/Signup');
};
const goToPresupuesto = (router)=>{
    router.push('/Presupuesto');
};
const goToAlertas = (router)=>{
    router.push('/Alertas');
};
if (typeof globalThis.$RefreshHelpers$ === 'object' && globalThis.$RefreshHelpers !== null) {
    __turbopack_context__.k.registerExports(module, globalThis.$RefreshHelpers$);
}
}}),
}]);

//# sourceMappingURL=services_clientFunctions_functions_tsx_0aa71408._.js.map