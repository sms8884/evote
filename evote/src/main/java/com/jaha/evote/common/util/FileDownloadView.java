/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 *
 * 2016. 7. 12.
 */
package com.jaha.evote.common.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.view.AbstractView;

import com.jaha.evote.domain.common.FileInfo;

/**
 * <pre>
 * Class Name : FileDownloadView.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 7. 12.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 7. 12.
 * @version 1.0
 */
public class FileDownloadView extends AbstractView {

    public FileDownloadView() {
        super.setContentType("application/octet-stream");
    }

    @Override
    protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        FileInfo fileInfo = (FileInfo) model.get("fileInfo");

        String fileNm = fileInfo.getFileNm();    // 파일명
        String filePath = fileInfo.getFilePath();  // 파일경로
        String fileSrcNm = fileInfo.getFileSrcNm();  // 원본파일명

        File file = new File(filePath, fileNm);

        response.setContentType(getContentType());
        response.setContentLength((int) file.length());
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

        OutputStream out = response.getOutputStream();
        FileInputStream in = null;

        try {
            in = new FileInputStream(file);
            FileCopyUtils.copy(in, out);
            out.flush();
        } catch (Exception e) {
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
