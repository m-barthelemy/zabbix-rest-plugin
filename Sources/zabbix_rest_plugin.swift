
import Glibc
import Foundation
import ZabbixModule


//Called by Zabbix at startup time
@_cdecl("zbx_module_init")
func zbx_module_init() -> Int32 {
    Zabbix.log(message: "[zbx-rest]: init")
    
    return Zabbix.registerMetrics(metricsList: [
        "rest.request"         : RestMetrics.request,
        "rest.status"          : RestMetrics.status,
        //"rest.diff"
        //"rest.discover"           : MongoMetrics.discoverDbsAndCollections,
    ] )
}


//Called by Zabbix at stop time
@_cdecl("zbx_module_uninit")
func zbx_module_uninit() -> Int32 {
    // Nothing to clean, just return
    return 0;
}


enum RestModuleError : Error {
    case BadUrl(String)             // Invalid MongoDB URL
    case BadResponseFormat(String)  // Invalid Mongo query
    case BadParameters(String)      // Invalid number of parameters
}


