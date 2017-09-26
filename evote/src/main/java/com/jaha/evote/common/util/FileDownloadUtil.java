/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.common.util;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * <pre>
 * Class Name : FileDownloadUtil.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 8. 24.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 8. 24.
 * @version 1.0
 */
public class FileDownloadUtil {

    private static final Log logger = LogFactory.getLog(FileDownloadUtil.class);

    /** 다운로드 버퍼 크기 */
    private static final int BUFFER_SIZE = 8192; // 8kb

    /** 문자 인코딩 */
    private static final String CHARSET = "UTF-8";

    /**
     * 생성자 - 객체 생성 불가
     */
    private FileDownloadUtil() {
        // do nothing;
    }

    /**
     * 지정된 파일을 다운로드 한다.
     * 
     * @param request
     * @param response
     * @param file
     *        다운로드할 파일
     * 
     * @throws ServletException
     * @throws IOException
     */
    public static void download(HttpServletRequest request, HttpServletResponse response, File file, String fileSrcNm) throws ServletException, IOException {

        String mimetype = request.getSession().getServletContext().getMimeType(file.getName());

        if (file == null || !file.exists() || file.length() <= 0 || file.isDirectory()) {
            throw new IOException("파일 객체가 Null 혹은 존재하지 않거나 길이가 0, 혹은 파일이 아닌 디렉토리이다.");
        }

        InputStream is = null;

        try {
            is = new FileInputStream(file);
            download(request, response, is, file.getName(), file.length(), fileSrcNm, mimetype);
        } finally {
            try {
                is.close();
            } catch (Exception ex) {
            }
        }
    }

    /**
     * 해당 입력 스트림으로부터 오는 데이터를 다운로드 한다.
     * 
     * @param request
     * @param response
     * @param is
     *        입력 스트림
     * @param filename
     *        파일 이름
     * @param filesize
     *        파일 크기
     * @param mimetype
     *        MIME 타입 지정
     * @throws ServletException
     * @throws IOException
     */
    public static void download(HttpServletRequest request, HttpServletResponse response, InputStream is, String filename, long filesize, String fileSrcNm, String mimetype)
            throws ServletException, IOException {
        String mime = mimetype;

        if (mimetype == null || mimetype.length() == 0) {
            mime = "application/octet-stream;";
        }


        byte[] buffer = new byte[BUFFER_SIZE];

        response.setContentType(mime + "; charset=" + CHARSET);

        String userAgent = request.getHeader("User-Agent");
        String fileName = null;

        if (userAgent.indexOf("MSIE") > -1 || userAgent.indexOf("Trident") > -1) {
            fileName = URLEncoder.encode(fileSrcNm, "UTF-8").replaceAll("\\+", "%20");;
        } else {
            fileName = new String(fileSrcNm.getBytes("UTF-8"), "ISO-8859-1");
        }

        String header = "attachment; filename=" + fileName + ";";

        response.setHeader("Content-Disposition", header);
        response.setHeader("Content-Transfer-Encoding", "binary");

        if (filesize > 0) {
            response.setHeader("Content-Length", "" + filesize);
        }

        BufferedInputStream in = null;
        BufferedOutputStream out = null;

        try {
            in = new BufferedInputStream(is);
            out = new BufferedOutputStream(response.getOutputStream());
            int read = 0;

            while ((read = in.read(buffer)) != -1) {
                out.write(buffer, 0, read);
            }
        } catch (IOException e) {
            logger.info(e.getMessage());
        } finally {
            try {
                if (in != null) {
                    in.close();
                }
            } catch (IOException ex) {
            }
            try {
                if (out != null) {
                    out.close();
                }
            } catch (IOException ex) {
            }
        }
    }

}
