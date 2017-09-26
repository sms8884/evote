/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 *
 * 2016. 7. 12.
 */
package com.jaha.evote.common.util;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.multipart.MultipartFile;

import com.jaha.evote.domain.common.FileInfo;
import com.jaha.evote.domain.type.FileGrpType;
import com.jaha.evote.domain.type.FileType;

/**
 * <pre>
 * Class Name : FileUploadUtil.java
 * Description : 파일 업로드 유틸
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
@Component
public class FileUploadUtil {

    private final Logger logger = LoggerFactory.getLogger(getClass());

    public static final String STORE_FILE_NAME_KEY = "storeFileName";
    public static final String STORE_FILE_PATH_KEY = "storeFilePath";
    public static final String STORE_FILE_EXT_KEY = "storeFileExt";

    @Value("${file.storage.path}")
    private String storagePath;

    @Value("${file.allow.ext}")
    private String fileAllowExt;

    @Value("${file.max.upload.size}")
    private String maxUploadSize;

    public Map<String, String> saveFile(final MultipartFile file) {
        return saveFile(file, FileGrpType.TEMP);
    }

    public FileInfo getSavedFileInfo(final MultipartFile multipartFile, final FileGrpType fileGrpType, final FileType fileType) {
        if (multipartFile != null && StringUtils.isNotEmpty(multipartFile.getOriginalFilename())) {
            FileInfo fileInfo = new FileInfo();
            Map<String, String> storeFileMap = this.saveFile(multipartFile, fileGrpType);
            fileInfo.setFileNm(storeFileMap.get(STORE_FILE_NAME_KEY));
            fileInfo.setFilePath(storeFileMap.get(STORE_FILE_PATH_KEY));
            fileInfo.setFileExt(storeFileMap.get(STORE_FILE_EXT_KEY));
            fileInfo.setFileSrcNm(multipartFile.getOriginalFilename());
            fileInfo.setFileGrpType(fileGrpType);
            fileInfo.setFileType(fileType);
            fileInfo.setFileSize(multipartFile.getSize());
            return fileInfo;
        }
        return null;
    }

    public Map<String, String> saveFile(final MultipartFile file, final FileGrpType fileGrpType) {

        List<String> permitExt = null;
        if (StringUtils.isNotEmpty(fileAllowExt)) {
            permitExt = Arrays.asList(fileAllowExt.trim().replace(" ", "").toUpperCase().split("[|]"));
        }

        final String orgFileName = file.getOriginalFilename();
        if (StringUtils.isEmpty(orgFileName)) {
            return null;
        }
        final String orgExt = FilenameUtils.getExtension(orgFileName);
        if (StringUtils.isEmpty(orgExt) || !permitExt.contains(orgExt.toUpperCase().trim())) {
            throw new SecurityException("Filtered by file extenstion : " + orgExt);
        }

        final int intMaxUploadSize = NumberUtils.parseInt(maxUploadSize, 2097152);
        if (file.getSize() > intMaxUploadSize) {
            throw new MaxUploadSizeExceededException(intMaxUploadSize);
        }

        final String strFilePath = getFilePath(fileGrpType);
        final File fileRootPath = new File(storagePath);

        final File storePath = new File(fileRootPath, strFilePath);
        if (!storePath.isDirectory()) {
            if (!storePath.mkdirs()) {
                throw new IllegalStateException("Create storage directory has been failed");
            }
        }
        final File targetFile = generateStoreFile(storePath);

        final Map<String, String> result = new HashMap<>();

        try {
            if (!targetFile.createNewFile()) {
                throw new IllegalStateException("Target file already exist");
            }
            file.transferTo(targetFile);
            result.put(STORE_FILE_NAME_KEY, targetFile.getName());
            result.put(STORE_FILE_PATH_KEY, targetFile.getParent().replace("\\", "/"));
            result.put(STORE_FILE_EXT_KEY, orgExt.toUpperCase());
            return result;
        } catch (IOException e) {
            if (targetFile.exists()) {
                try {
                    if (!targetFile.delete()) {
                        logger.warn("Delete file has been failed : " + targetFile.getAbsolutePath());
                    }
                } catch (Exception ignored) {
                    logger.warn("Delete file has been failed : " + targetFile.getAbsolutePath(), ignored);
                }
            }
            throw new IllegalStateException(e);
        }
    }

    public void deleteFile(FileInfo param) {
        if (param != null) {
            File file = new File(param.getFilePath() + "/" + param.getFileNm());
            if (file.exists()) {
                file.delete();
            }
        }
    }

    public String getEncFileInfo(final FileInfo fileInfo) {
        if (fileInfo != null) {
            String encFileInfo = XecureUtil.encString(fileInfo.getFilePath() + "|" + fileInfo.getFileNm() + "|" + fileInfo.getFileSrcNm());
            return encFileInfo.replace("/", "|");
        }
        return null;
    }

    public String getDecFileInfo(final String encFileInfo) {
        if (encFileInfo != null) {
            return XecureUtil.decString(encFileInfo.replace("|", "/"));
        }
        return null;
    }

    private String getFilePath(final FileGrpType fileGrpType) {
        final Calendar calendar = Calendar.getInstance();

        // @formatter:off
        final StringBuilder builder = new StringBuilder();
        builder.append("/").append(fileGrpType)
               .append("/").append(calendar.get(Calendar.YEAR))
               .append("/").append(calendar.get(Calendar.MONTH) + 1)
               .append("/").append(calendar.get(Calendar.DATE));
        // @formatter:on

        return builder.toString();
    }

    private File generateStoreFile(final File storePath) {
        File targetFile = new File(storePath, String.valueOf(System.nanoTime()));
        if (targetFile.exists()) {
            return generateStoreFile(storePath);
        }
        return targetFile;
    }

}
