package com.jaha.evote.common.filter;

import java.util.Map;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import org.springframework.util.MultiValueMap;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.support.DefaultMultipartHttpServletRequest;

public class RequestXSSWrapper extends DefaultMultipartHttpServletRequest {

    public RequestXSSWrapper(HttpServletRequest request) {
        super(request);

    }

    public RequestXSSWrapper(HttpServletRequest request, MultiValueMap<String, MultipartFile> multipartFiles, Map<String, String[]> multipartParameters,
            Map<String, String> multipartParameterContentTypes) {
        super(request, multipartFiles, multipartParameters, multipartParameterContentTypes);
    }

    @Override
    public String getParameter(String name) {
        String value = super.getParameter(name);

        if (value == null) {
            return null;
        }
        String encodedValue = stripXSS(value);

        return encodedValue;
    }

    public String[] getParameterValues(String parameter) {

        String[] values = super.getParameterValues(parameter);

        if (values == null) {
            return null;
        }

        int count = values.length;
        String[] encodedValues = new String[count];
        for (int i = 0; i < count; i++) {
            encodedValues[i] = stripXSS(values[i]);
        }
        return encodedValues;
    }

    private String stripXSS(String value) {
        if (value == null)
            return null;

        // value = value.replaceAll("", "");
        // return StringUtils.clearXSS(value);

        // return XssFilterUtils.applyFilter(value);
        // /**
        // NOTE: It's highly recommended to use the ESAPI library and uncomment the following line to
        // avoid encoded attacks.
        // value = ESAPI.encoder().canonicalize(value);

        // Avoid null characters
        value = value.replaceAll("", "");

        // Avoid anything between script tags
        Pattern scriptPattern = Pattern.compile("<script>(.*?)</script>", Pattern.CASE_INSENSITIVE);
        value = scriptPattern.matcher(value).replaceAll("");

        // Avoid anything between style tags
        // scriptPattern = Pattern.compile("<style>(.*?)</style>", Pattern.CASE_INSENSITIVE);
        // value = scriptPattern.matcher(value).replaceAll("");


        // Avoid anything in a src='...' type of expression
        // scriptPattern = Pattern.compile("src[\r\n]*=[\r\n]*\\\'(.*?)\\\'", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
        // value = scriptPattern.matcher(value).replaceAll("");
        //
        // scriptPattern = Pattern.compile("src[\r\n]*=[\r\n]*\\\"(.*?)\\\"", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
        // value = scriptPattern.matcher(value).replaceAll("");
        //
        // // Avoid anything in a href='...' type of expression
        // scriptPattern = Pattern.compile("href[\r\n]*=[\r\n]*\\\"(.*?)\\\"", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
        // value = scriptPattern.matcher(value).replaceAll("");

        // Avoid anything in a oninput='...' type of expression
        scriptPattern = Pattern.compile("oninput[\r\n]*=[\r\n]*(.*?)", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
        value = scriptPattern.matcher(value).replaceAll("");

        // Avoid anything in a onfocus='...' type of expression
        scriptPattern = Pattern.compile("onfocus[\r\n]*=[\r\n]*(.*?)", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
        value = scriptPattern.matcher(value).replaceAll("");

        // Avoid anything in a onforminput='...' type of expression
        scriptPattern = Pattern.compile("onforminput[\r\n]*=[\r\n]*(.*?)", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
        value = scriptPattern.matcher(value).replaceAll("");

        // Avoid anything in a onerror='...' type of expression
        scriptPattern = Pattern.compile("onerror[\r\n]*=[\r\n]*(.*?)", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
        value = scriptPattern.matcher(value).replaceAll("");

        // Avoid anything in a onerror='...' type of expression
        scriptPattern = Pattern.compile("background[\r\n]*=[\r\n]*(.*?)", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
        value = scriptPattern.matcher(value).replaceAll("");

        // Remove any lonesome </script> tag
        scriptPattern = Pattern.compile("</script>", Pattern.CASE_INSENSITIVE);
        value = scriptPattern.matcher(value).replaceAll("");

        // Remove any lonesome </iframe> tag
        scriptPattern = Pattern.compile("</iframe>", Pattern.CASE_INSENSITIVE);
        value = scriptPattern.matcher(value).replaceAll("");

        // Remove any lonesome <script ...> tag
        scriptPattern = Pattern.compile("<script(.*?)>", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
        value = scriptPattern.matcher(value).replaceAll("");

        // Remove any lonesome <meta ...> tag
        scriptPattern = Pattern.compile("<meta(.*?)>", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
        value = scriptPattern.matcher(value).replaceAll("");

        // Remove any lonesome <img ...> tag
        // scriptPattern = Pattern.compile("<img(.*?)>", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
        // value = scriptPattern.matcher(value).replaceAll("");

        // Remove any lonesome <link ...> tag
        scriptPattern = Pattern.compile("<link(.*?)>", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
        value = scriptPattern.matcher(value).replaceAll("");

        // Remove any lonesome <table ...> tag
        // scriptPattern = Pattern.compile("<table(.*?)>", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
        // value = scriptPattern.matcher(value).replaceAll("");

        // Remove any lonesome <table ...> tag
        scriptPattern = Pattern.compile("<iframe(.*?)>", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
        value = scriptPattern.matcher(value).replaceAll("");

        // Remove any lonesome <div ...> tag
        // scriptPattern = Pattern.compile("<div(.*?)>", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
        // value = scriptPattern.matcher(value).replaceAll("");

        // Avoid eval(...) expressions
        scriptPattern = Pattern.compile("eval\\((.*?)\\)", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
        value = scriptPattern.matcher(value).replaceAll("");

        // Avoid expression(...) expressions
        scriptPattern = Pattern.compile("expression\\((.*?)\\)", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
        value = scriptPattern.matcher(value).replaceAll("");

        // Avoid javascript:... expressions
        scriptPattern = Pattern.compile("javascript:", Pattern.CASE_INSENSITIVE);
        value = scriptPattern.matcher(value).replaceAll("");

        // Avoid vbscript:... expressions
        scriptPattern = Pattern.compile("vbscript:", Pattern.CASE_INSENSITIVE);
        value = scriptPattern.matcher(value).replaceAll("");

        // Avoid onload= expressions
        scriptPattern = Pattern.compile("onload(.*?)=", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
        value = scriptPattern.matcher(value).replaceAll("");

        // Remove any lonesome <table ...> tag
        // scriptPattern = Pattern.compile("\"/>", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
        // value = scriptPattern.matcher(value).replaceAll("");
        //
        // scriptPattern = Pattern.compile("\">", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
        // value = scriptPattern.matcher(value).replaceAll("");

        scriptPattern = Pattern.compile("<(\\s)?script(\\s)?>", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
        value = scriptPattern.matcher(value).replaceAll("&lt;script&gt;");

        scriptPattern = Pattern.compile("</(\\s)?script(\\s)?>", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
        value = scriptPattern.matcher(value).replaceAll("&lt;/script&gt;");

        // scriptPattern = Pattern.compile("<(\\s)?style(\\s)?>", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
        // value = scriptPattern.matcher(value).replaceAll("&lt;style&gt;");

        // scriptPattern = Pattern.compile("</(\\s)?style(\\s)?>", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
        // value = scriptPattern.matcher(value).replaceAll("&lt;/style&gt;");

        return value;
    }
}
