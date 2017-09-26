/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.common.util;

import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.io.FilenameUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * <pre>
 * Class Name : ExcelUploadUtil.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 9. 29.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 9. 29.
 * @version 1.0
 */
public class ExcelUploadUtil {

    private static final Logger logger = LoggerFactory.getLogger(ExcelUploadUtil.class);

    public static List<String[]> getExcelData(final String filePath, final String fileSrcNm) {
        String fileExt = FilenameUtils.getExtension(fileSrcNm);
        if (StringUtils.isNotEmpty(fileExt)) {
            if ("XLS".equalsIgnoreCase(fileExt)) {
                return getXLS(filePath);
            } else if ("XLSX".equalsIgnoreCase(fileExt)) {
                return getXLSX(filePath);
            }
        }
        return null;
    }

    @SuppressWarnings("resource")
    private static List<String[]> getXLS(final String filePath) {

        List<String[]> list = null;
        FileInputStream fis = null;

        try {

            fis = new FileInputStream(filePath);

            HSSFWorkbook workbook = new HSSFWorkbook(fis);
            int rowindex = 0;
            int columnindex = 0;
            HSSFSheet sheet = workbook.getSheetAt(0);   // 첫번째 시트
            int rows = sheet.getPhysicalNumberOfRows(); // row count
            HSSFRow row = null;
            HSSFCell cell = null;

            String[] values;
            String value = null;

            list = new ArrayList<>();

            for (rowindex = 1; rowindex < rows; rowindex++) {
                row = sheet.getRow(rowindex);
                if (row != null) {

                    int cells = row.getPhysicalNumberOfCells(); // cell count
                    values = new String[cells];

                    for (columnindex = 0; columnindex <= cells; columnindex++) {

                        cell = row.getCell(columnindex);
                        value = "";

                        if (cell == null) {
                            continue;
                        } else {
                            switch (cell.getCellType()) {
                                case HSSFCell.CELL_TYPE_FORMULA:
                                    value = cell.getCellFormula();
                                    break;
                                case HSSFCell.CELL_TYPE_NUMERIC:
                                    value = String.valueOf(cell.getNumericCellValue());
                                    break;
                                case HSSFCell.CELL_TYPE_STRING:
                                    value = String.valueOf(cell.getStringCellValue());
                                    break;
                                case HSSFCell.CELL_TYPE_BLANK:
                                    value = String.valueOf(cell.getBooleanCellValue());
                                    break;
                                case HSSFCell.CELL_TYPE_ERROR:
                                    value = String.valueOf(cell.getErrorCellValue());
                                    break;
                            }
                        }

                        //logger.debug("### CELL [{}]", value);
                        values[columnindex] = value;

                    }

                    list.add(values);
                }
            }

        } catch (Exception e) {
            logger.error("### excelUpload error : [{}]", e.getMessage());
            list = null;
        } finally {
            if (fis != null) {
                try {
                    fis.close();
                } catch (Exception e) {
                }
            }
        }

        return list;

    }

    @SuppressWarnings("resource")
    private static List<String[]> getXLSX(final String filePath) {

        List<String[]> list = null;
        FileInputStream fis = null;

        try {

            fis = new FileInputStream(filePath);

            XSSFWorkbook workbook = new XSSFWorkbook(fis);
            int rowindex = 0;
            int columnindex = 0;
            XSSFSheet sheet = workbook.getSheetAt(0);   // 첫번째 시트
            int rows = sheet.getPhysicalNumberOfRows(); // row count
            XSSFRow row = null;
            XSSFCell cell = null;

            String[] values = null;
            String value = null;

            list = new ArrayList<>();

            for (rowindex = 1; rowindex < rows; rowindex++) {
                row = sheet.getRow(rowindex);
                if (row != null) {

                    int cells = row.getPhysicalNumberOfCells(); // cell count
                    values = new String[cells];

                    for (columnindex = 0; columnindex <= cells; columnindex++) {
                        cell = row.getCell(columnindex);
                        value = "";
                        if (cell == null) {
                            continue;
                        } else {
                            switch (cell.getCellType()) {
                                case XSSFCell.CELL_TYPE_FORMULA:
                                    value = cell.getCellFormula();
                                    break;
                                case XSSFCell.CELL_TYPE_NUMERIC:
                                    value = String.valueOf(cell.getNumericCellValue());
                                    break;
                                case XSSFCell.CELL_TYPE_STRING:
                                    value = String.valueOf(cell.getStringCellValue());
                                    break;
                                case XSSFCell.CELL_TYPE_BLANK:
                                    value = String.valueOf(cell.getBooleanCellValue());
                                    break;
                                case XSSFCell.CELL_TYPE_ERROR:
                                    value = String.valueOf(cell.getErrorCellValue());
                                    break;
                            }
                        }

                        //logger.debug("### CELL [{}]", value);
                        values[columnindex] = value;
                    }

                    list.add(values);

                }
            }

        } catch (Exception e) {
            logger.error("### excelUpload error : [{}]", e.getMessage());
            list = null;
        } finally {
            if (fis != null) {
                try {
                    fis.close();
                } catch (Exception e) {
                }
            }
        }

        return list;

    }

}
