{
  "subject": "acct:{{ .Values.webfinger.subject }}",
  "links": [
    {
      "rel": "http://openid.net/specs/connect/1.0/issuer",
      "href": "{{ .Values.webfinger.issuer }}"
    }
  ]
}