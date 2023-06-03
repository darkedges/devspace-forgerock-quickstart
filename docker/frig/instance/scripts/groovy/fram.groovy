// return next.handle(context, request).thenAsync( new AsyncFunction() {
//   Promise apply (response) {
//     if (response.status == Status.OK && request.uri.path =='/openam/json/realms/root/authenticate') {
//       switch(request.method) {
//         case "POST": 
//           def userAgent = request.headers['User-Agent'].firstValue?request.headers['User-Agent'].firstValue.toLowerCase():"";
//           def android = userAgent.contains("android") || userAgent.contains("mobile;");
//           def passkeyUpdate = response.entity.json.callbacks?.getAt(2)?.getAt('output')?.getAt(1)?.value == 'webAuthnOutcome';
//           if (passkeyUpdate ) {
//             def textOutputCallback1 = response.entity.json.callbacks[0].output[0].value;
//             def searchValue = "authenticatorSelection: {\"userVerification\":\"preferred\"}";
//             def replaceValue = "authenticatorSelection :{\"authenticatorAttachment\":\"platform\",\"requireResidentKey\":true,\"residentKey\":\"required\",\"userVerification\":\"required\"}, extensions: {\"credProps\": true}";
//             def json = response.entity.json;
//             def v = textOutputCallback1.replace(searchValue,replaceValue);
//             json.callbacks[0].output[0].value = "var event = new CustomEvent(\"webauthn:registration\", {detail: 'hello'}); console.log(event); window.dispatchEvent(event);\n"+v;
//             response.entity.json = json;
//           }
//           break;
//         default:
//           break;
//       }
//     }
//     return Response.newResponsePromise(response)
//   }
// })
return next.handle(context, request);