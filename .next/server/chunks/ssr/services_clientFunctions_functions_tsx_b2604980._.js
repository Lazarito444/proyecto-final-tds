module.exports = {

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
}}),

};

//# sourceMappingURL=services_clientFunctions_functions_tsx_b2604980._.js.map