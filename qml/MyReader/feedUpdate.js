WorkerScript.onMessage = function(message) {
    var src = message.source;
    var auth = message.auth;
    var sid = message.sid;
    var feedMax = message.feedMax
    //var model = message.model;

    var doneCbk  = function(result){
        if(result.code==1){
            WorkerScript.sendMessage({timeout:1});
        }else if(result.code==-1){
            WorkerScript.sendMessage({error:result.error});
        }else if(result.code==0){
            //model.clear();
            var doc = result.data;
            var jresult = [];
            for (var ii = 0; ii < doc.childNodes.length; ++ii) {
                if(doc.childNodes[ii].nodeName=="entry"){
                    var entry = doc.childNodes[ii]
                    var title,from,content;
                    for (var j = 0; j < entry.childNodes.length; ++j) {
                        var nodename = entry.childNodes[j].nodeName;
                        if(nodename=="title"){
                            title = entry.childNodes[j].firstChild.nodeValue;
                        }else if(nodename=="source"){
                            from = entry.childNodes[j].childNodes[1].firstChild.nodeValue;
                        }else if(nodename=="summary"||nodename=="content"){
                            content =  entry.childNodes[j].firstChild.nodeValue;
                            //console.log(content)
                        }
                    }
                    var obj = {title:title,from:from,content:content,link:""};
//                    model.append();
                    jresult.push(obj);
                }else if(doc.childNodes[ii].nodeName=="list"){

                    var list = doc.firstChild
                    if(list.attributes[0].value == "subscriptions"){
                        for(var k = 0; k < list.childNodes.length; ++k){
                            var obj = list.childNodes[k]
                            var title,link;
                            title = obj.childNodes[1].firstChild.nodeValue;
                            link = "https://www.google.com/reader/atom/"+obj.childNodes[0].firstChild.nodeValue;
                            //model.append({title:title,link:link,from:"",content:""});
                            var obj = {title:title,link:link,from:"",content:""};
                            jresult.push(obj);
                        }
                    }else  if(list.attributes[0].value == "tags"){
                        for(var k = 0; k < list.childNodes.length; ++k){
                            var obj = list.childNodes[k]
                            var title,link;
                            link = "https://www.google.com/reader/atom/"+obj.childNodes[0].firstChild.nodeValue;
                            title = link.substr(link.lastIndexOf('/')+1)
                            //model.append({title:title,link:link,from:"",content:""});
                            var obj = {title:title,link:link,from:"",content:""};
                            jresult.push(obj);
                        }
                    }


                }
            }
            //model.sync();
            WorkerScript.sendMessage({src:src,data:jresult});
        }
    }

    if(auth&&sid){
        getFeeds(src,auth,sid,feedMax,doneCbk);
    }
    else{
         WorkerScript.sendMessage({error:"auth info error"});
    }

}



//更新订阅
function getFeeds(slink,authStr,sid,feedMax,callback){
    var http = new XMLHttpRequest();
    http.onreadystatechange = function() {
        if (http.readyState == XMLHttpRequest.DONE) {
            console.log("getFeeds:"+http.status+"  "+http.statusText);
            //console.log("resp:"+http.getAllResponseHeaders());
            if(http.status==200){
                callback({code:0,data:http.responseXML.documentElement,auth:authStr,sid:sid});

            }else if(http.status==401){
                callback({code:1});

            } else{
                callback({code:-1,error:http.status+"  "+http.statusText});
            }
        }
    }
    http.open("GET", slink+"?n="+feedMax);
    http.setRequestHeader("Authorization","GoogleLogin auth="+authStr);
    http.setRequestHeader("Cookie","SID="+sid);
    http.setRequestHeader("accept-encoding", "gzip, deflate")
    //console.log("auth string:"+authStr+"\n\n sid="+sid)
    try {
      console.log("http getFeeds send "+slink)
      http.send();
    } catch (e) {
        console.log(e)
        callback({code:-1,error:e});
    }
}







