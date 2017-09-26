/**
 * Copyright (c) 2016 by jahasmart.com. All rights reserved.
 *
 * 2016. 7. 11.
 */
package com.jaha.evote.controller.common;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.jaha.evote.common.exception.EvoteFileNotFoundException;
import com.jaha.evote.common.util.FileUploadUtil;
import com.jaha.evote.domain.common.CodeDetail;
import com.jaha.evote.domain.common.FileInfo;
import com.jaha.evote.domain.type.CodeType;
import com.jaha.evote.domain.type.FileGrpType;
import com.jaha.evote.service.CodeService;
import com.jaha.evote.service.FileService;

/**
 * <pre>
 * Class Name : FileController.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 7. 11.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 7. 11.
 * @version 1.0
 */
@Controller
public class FileController {

    private static final Logger logger = LoggerFactory.getLogger(FileController.class);

    @Autowired
    private FileUploadUtil fileUploadUtil;

    @Autowired
    private FileService fileService;

    @Autowired
    private CodeService codeService;

    /**
     * 파일 다운로드
     * 
     * @param request
     * @param fileSeq
     * @return
     */
    @RequestMapping(value = "/file-download/{fileSeq}")
    public ModelAndView fileDownload(HttpServletRequest request, @PathVariable(value = "fileSeq") String fileSeq) {
        long lngFileSeq = 0L;
        try {
            lngFileSeq = Long.parseLong(fileSeq);
        } catch (NumberFormatException e) {
            logger.info("### NumberFormatException ::: fileSeq [{}]", fileSeq);
            throw new EvoteFileNotFoundException("### 파일정보 없음");
        }
        FileInfo fileInfo = fileService.selectFileInfo(lngFileSeq);
        return new ModelAndView("fileDownloadView", "fileInfo", fileInfo);
    }

    /**
     * 제안 샘플 파일 다운로드
     * 
     * @param request
     * @param fileSeq
     * @return
     */
    @RequestMapping(value = "/file-download/etc/{fileSeq}")
    public ModelAndView etcFileDownload(HttpServletRequest request, @PathVariable(value = "fileSeq") String fileSeq) {

        String cdGrpId = CodeType.CODE_GROUP_ETC_FILE.getCode();
        String cdId = "ETC" + fileSeq;

        CodeDetail codeDetail = codeService.getCodeInfo(cdGrpId, cdId);

        if (codeDetail == null) {
            throw new EvoteFileNotFoundException("### 파일정보 없음");
        }

        FileInfo fileInfo = new FileInfo();
        fileInfo.setFileNm(codeDetail.getData2());
        fileInfo.setFilePath(codeDetail.getData1());
        fileInfo.setFileSrcNm(codeDetail.getData3());

        return new ModelAndView("fileDownloadView", "fileInfo", fileInfo);
    }

    /**
     * 파일 업로드 - 임시 폴더에 저장 후 파일 정보 반환
     * 
     * @param request
     * @param response
     * @param file
     * @return
     */
    @RequestMapping(value = "/file-upload", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, String> fileUpload(HttpServletRequest request, HttpServletResponse response, @RequestParam(value = "mfile") MultipartFile file) {

        Map<String, String> storeFileMap = fileUploadUtil.saveFile(file);

        storeFileMap.put("orgFileName", file.getOriginalFilename());
        storeFileMap.put("size", String.valueOf(file.getSize()));

        logger.debug("storeFileMap: {}", storeFileMap);

        return storeFileMap;

    }

    /**
     * 에디터 이미지 업로드
     * 
     * @param imageFile
     * @return
     */
    @RequestMapping(value = "/editor/image-upload", method = RequestMethod.POST)
    @ResponseBody
    public String editorImageUpload(@RequestParam(value = "upload", required = false) MultipartFile imageFile) {

        try {

            FileInfo fileInfo = fileUploadUtil.getSavedFileInfo(imageFile, FileGrpType.EDITOR, null);
            String encFileInfo = fileUploadUtil.getEncFileInfo(fileInfo);

            JSONObject obj = new JSONObject();
            obj.put("fileName", fileInfo.getFileSrcNm());
            obj.put("uploaded", 1);
            obj.put("url", "/editor/image-download/" + encFileInfo);

            return obj.toString();

        } catch (Exception e) {
            logger.error("### editor image upload FAIL :: {}", e.getMessage());
        }

        return "error";
    }

    /**
     * 에디터 이미지 다운로드
     * 
     * @param request
     * @param encFileName
     * @return
     */
    @RequestMapping(value = "/editor/image-download/{encFileInfo}")
    public ModelAndView editorImageDownload(HttpServletRequest request, @PathVariable(value = "encFileInfo") String encFileInfo) {

        try {

            String decFileInfo = fileUploadUtil.getDecFileInfo(encFileInfo);

            String[] arrFileInfo = decFileInfo.split("[|]");

            if (arrFileInfo.length < 3) {
                throw new EvoteFileNotFoundException("");
            }

            String filePath = arrFileInfo[0];
            String fileName = arrFileInfo[1];
            String fileSrcNm = arrFileInfo[2];

            FileInfo fileInfo = new FileInfo();
            fileInfo.setFileNm(fileName);
            fileInfo.setFilePath(filePath);
            fileInfo.setFileSrcNm(fileSrcNm);

            return new ModelAndView("fileDownloadView", "fileInfo", fileInfo);

        } catch (Exception e) {

            logger.error("### editor image download FAIL :: {}", e.getMessage());

        }

        return null;

    }

    //    // 파일 업로드 샘플
    //    @RequestMapping(value = "/sample/file-upload", method = RequestMethod.POST)
    //    public String sampleFileUpload(HttpServletRequest request, HttpServletResponse response, @RequestParam(value = "sampleFile") MultipartFile file) {
    //
    //        Map<String, String> storeFileMap = fileUploadUtil.saveFile(file, FileGrpType.VOTE);
    //
    //        long fileGrpSeq = 1L; // 원본 게시물 일련번호
    //        int fileOrd = 1; // 파일 순서
    //        String fileDesc = "sample file"; // 파일 설명
    //
    //        FileInfo fileVO = new FileInfo();
    //        fileVO.setFileNm(storeFileMap.get("storeFileName"));
    //        fileVO.setFilePath(storeFileMap.get("storeFilePath"));
    //        fileVO.setFileExt(storeFileMap.get("storeFileExt"));
    //
    //        fileVO.setFileSrcNm(file.getOriginalFilename());
    //        fileVO.setFileGrpType(FileGrpType.VOTE);
    //        fileVO.setFileType(FileType.IMAGE);
    //        fileVO.setFileSize(file.getSize());
    //
    //        fileVO.setFileGrpSeq(fileGrpSeq);
    //        fileVO.setFileOrd(fileOrd);
    //        fileVO.setFileDesc(fileDesc);
    //
    //        fileService.insertFileInfo(fileVO);
    //
    //        logger.debug("fileMap: {}", storeFileMap);
    //
    //        return "redirect:/sample/file";
    //
    //    }
    //
    //    // 파일 삭제 샘플
    //    @RequestMapping(value = "/sample/file-delete/{delFileSeq}")
    //    public String sampleFileDelete(HttpServletRequest request, @PathVariable(value = "delFileSeq") long delFileSeq) {
    //        fileService.deleteFileInfo(delFileSeq);
    //        return "redirect:/sample/file";
    //    }

}
