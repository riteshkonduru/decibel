package org.deloitte.decibel.controller;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ByteArrayEntity;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.util.EntityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

@Controller
public class AuthController {
	
	//this method is to call decibel jsp page
	//open it in brower using the below link
	//http://localhost:8080/decibel-service/index
	@RequestMapping(value = "/index", method = RequestMethod.GET)
	public String index() {
		System.out.println("=====================================");
	    return "index";//this call JSP page
	}
	//this method is to call decibel html page.
	//open it in brower using the below link
	//http://localhost:8080/decibel-service/static
	@RequestMapping(value = "/static", method = RequestMethod.GET, produces = "text/html")
	public String index1() {
		System.out.println("=====================================Ritesh");
		return "redirect:/pages/index2.html"; //this calls static html page
		//return "redirect:/pages/static.html";
	    //return "redirect:/resources/scripts/static.html";
	    
	}
	
	
	
	
/*static final Properties properties = new Properties();
	//Hello
	static
	{
		try 
		{
			properties.load(AuthController.class.getResourceAsStream("/WEB-INF/custom.properties"));
			
		} 
		catch (IOException e) 
		{
			e.printStackTrace();
		}
	}
	@RequestMapping(value = "/auth", method = RequestMethod.GET, headers = "Accept=application/json")
	public String authUser() throws ClientProtocolException, IOException, ParserConfigurationException,
			SAXException, XPathExpressionException {
		String authUrl = "https://tabtest2.clearlight.deloitteinnovation.us/api/2.4/auth/signin";
		String token = null;
		String site_id = null;
		HttpClient authClient = HttpClientBuilder.create().build(); 
		HttpPost post = new HttpPost(authUrl);
		String pass = "e8Uj@w)&quot;Z5";
		String name = "sgarripelly";
		String contentUrl = "IAAP";
		String xml = "<tsRequest><credentials name='" + name + "' password='" + pass + "'><site contentUrl='"
				+ contentUrl + "'/></credentials></tsRequest>";
		HttpEntity entity = new ByteArrayEntity(xml.getBytes("UTF-8"));
		post.setHeader("Accept", "application/xml");
		post.setHeader("Content-type", "application/xml");
		post.setEntity(entity);
		HttpResponse response = authClient.execute(post);
		String result = EntityUtils.toString(response.getEntity());

		// parse response xml string...
		DocumentBuilderFactory f = DocumentBuilderFactory.newInstance();
		DocumentBuilder b = f.newDocumentBuilder();
		Document doc = b.parse(new ByteArrayInputStream(result.getBytes("UTF-8")));

		XPathFactory xPathfactory = XPathFactory.newInstance();
		XPath xpath = xPathfactory.newXPath();

		// path to get token
		XPathExpression expr = xpath.compile("//tsResponse/credentials[@token]");
		NodeList nl = (NodeList) expr.evaluate(doc, XPathConstants.NODESET);

		// path to get site id
		XPathExpression expr1 = xpath.compile("//tsResponse/credentials/site[@id]");
		NodeList nl1 = (NodeList) expr1.evaluate(doc, XPathConstants.NODESET);

		for (int i = 0; i < nl.getLength(); i++) {
			Node currentItem = nl.item(i);
			token = currentItem.getAttributes().getNamedItem("token").getNodeValue();

			Node currentItem1 = nl1.item(i);
			site_id = currentItem1.getAttributes().getNamedItem("id").getNodeValue();

		}

		String allViewsUrl = "https://tabtest2.clearlight.deloitteinnovation.us/api/2.4/sites/" + site_id + "/views";

		// subsequent GET call for all views
		HttpClient viewsClient = HttpClientBuilder.create().build();
		HttpGet request = new HttpGet(allViewsUrl);

		// add request header
		request.addHeader("X-Tableau-Auth", token);
		HttpResponse getResponse = viewsClient.execute(request);

		BufferedReader rd = new BufferedReader(new InputStreamReader(getResponse.getEntity().getContent()));

		StringBuffer strResult = new StringBuffer();
		String line = "";
		while ((line = rd.readLine()) != null) {
			strResult.append(line);
		}

		System.out.println("--------------------------------------------------");
		return "index";//this call JSP page
	}
	
	
	@RequestMapping(value = "/anthem", method = RequestMethod.GET, produces = "text/html")
	public String anthem() {
		System.out.println("=====================================Anthem HTML Ritesh");
		return "redirect:/pages/AnthemDashboard.html"; //this calls static html page
		//return "redirect:/pages/static.html";
	    //return "redirect:/resources/scripts/static.html";
	    
	}
	@RequestMapping(value = "/auth1", method = RequestMethod.GET, headers = "Accept=application/json")
    public @ResponseBody String authUser1() throws ClientProtocolException, IOException, ParserConfigurationException,
                               SAXException, XPathExpressionException, JSONException {
                
                
                //Hello
                 String authUrl = "https://trackotrack.atlassian.net/rest/auth/1/session";

                 HttpClient authClient = HttpClientBuilder.create().build();
                 HttpPost post = new HttpPost(authUrl);
                
                 JSONObject jObject = new JSONObject();
                 jObject.put("username", "neelsindwani@gmail.com");
                 jObject.put("password", "Nov@2017ns");
                
                 String userandpass = jObject.toString();

                 HttpEntity entity = new ByteArrayEntity(userandpass.getBytes());
                 post.setHeader("Accept", "application/json");
                 post.setHeader("Content-type", "application/json");
                 post.setEntity(entity);
                 HttpResponse response = authClient.execute(post);
                 String result = EntityUtils.toString(response.getEntity());
                 System.out.println("rest.."+result);         
                
                 String projsURL = "https://trackotrack.atlassian.net/rest/api/2/project";
                //https://trackotrack.atlassian.net/rest/api/2/issue/DL-10
                 HttpClient authClientProj = HttpClientBuilder.create().build();
                 HttpPost get = new HttpPost(projsURL);
                
                
                 get.setHeader("Accept", "application/json");
                 get.setHeader("Content-type", "application/json");
                 get.setHeader("-u", "neelsindwani@gmail.com:Nov@2017ns");
                 HttpResponse responseProjs = authClientProj.execute(get);
                 String projsResult = EntityUtils.toString(responseProjs.getEntity());
                  System.out.println("projsResult.."+projsResult);

                 return result;
    }
	
*/
}
