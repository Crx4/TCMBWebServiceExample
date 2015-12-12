<%@ WebService Language="VBScript" Class="ExchangeRates" %>

Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.ComponentModel
Imports System.Xml

<System.Web.Script.Services.ScriptService()>
<System.Web.Services.WebService(Namespace:="http://localhost")>
<System.Web.Services.WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)>
<ToolboxItem(False)>
Public Class ExchangeRates 
	Inherits WebService

	<WebMethod()>
	Public Function getCurrency(ByVal currencyCode As String) As XmlNode
	
		Dim request As System.Net.HttpWebRequest = System.Net.HttpWebRequest.Create("http://www.tcmb.gov.tr/kurlar/today.xml")
		Dim response As System.Net.HttpWebResponse = request.GetResponse()

		If response.StatusCode = System.Net.HttpStatusCode.OK Then

			Dim stream As System.IO.Stream = response.GetResponseStream()
			Dim reader As New System.IO.StreamReader(stream)
			Dim contents As String = reader.ReadToEnd()
			Dim document As New XmlDocument()
			
			document.LoadXml(contents)
			
			For Each currencyNode As XmlNode In document.SelectNodes("Tarih_Date/Currency")
				If currencyNode.Attributes("CurrencyCode").InnerText = currencyCode.ToUpper() Then
					Return currencyNode
				End If
			Next
			
			Return document.SelectSingleNode("Tarih_Date")
			
		Else
			Throw New Exception("Could not retrieve document from the URL, response code: " & response.StatusCode)
		End If
		
	End Function
End Class