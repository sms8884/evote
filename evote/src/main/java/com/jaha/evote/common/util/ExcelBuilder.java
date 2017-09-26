package com.jaha.evote.common.util;


import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.web.servlet.view.document.AbstractExcelView;

import com.jaha.evote.domain.type.AgeGroup;
import com.jaha.evote.domain.type.UserType;

/**
 * 엑셀다운로드
 */
public class ExcelBuilder extends AbstractExcelView {
    private HSSFWorkbook workbook;

    @SuppressWarnings("unchecked")
    @Override
    protected void buildExcelDocument(Map model, HSSFWorkbook workbook, HttpServletRequest request, HttpServletResponse response) throws Exception {
        this.workbook = workbook;
        List<HashMap> resultList = (List<HashMap>) model.get("resultList");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        HSSFSheet excelSheet = workbook.createSheet(sdf.format(new Date()) + "_결과");
        String fileName = (String) model.get("fileName") + "_" + sdf.format(new Date());
        String gubun = (String) model.get("gubun");

        if (gubun.equals("voteResult")) { // 투표 결과리스트
            HashMap voteInfo = (HashMap) model.get("voteInfo"); // 투표정보
            fileName += "_투표결과.xls";
            setvoteResultExcelVoteInfo(excelSheet, voteInfo);
            setvoteResultExcelHeader(excelSheet);
            setvoteResultExcelRows(excelSheet, resultList);
        } else if (gubun.equals("voterResult")) { // 투표자 리스트
            HashMap voteInfo = (HashMap) model.get("voteInfo"); // 투표정보
            fileName += "_투표자결과.xls";
            setvoterResultExcelHeader(excelSheet, voteInfo);
            setvoterResultExcelRows(excelSheet, resultList);
        } else if (gubun.equals("ProposalList")) { // 정책제안 리스트
            fileName += "_정책제안.xls";
            setProposalExcelHeader(excelSheet);
            setProposalExcelRows(excelSheet, resultList);
        }
        String browser = request.getHeader("User-Agent");
        String file_name = "";
        // 파일 인코딩
        if (browser.contains("MSIE") || browser.contains("Trident") || browser.contains("Chrome")) {
            file_name = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");
        } else {
            file_name = new String(fileName.getBytes("UTF-8"), "ISO-8859-1");
        }
        // 파일이름
        response.setHeader("Content-Disposition", "attachement; filename=\"" + file_name + "\"");
    }

    // 투표결과
    public void setvoteResultExcelVoteInfo(HSSFSheet excelSheet, HashMap voteInfo) {
        HSSFRow voteInfo1 = excelSheet.createRow(0);
        voteInfo1.createCell(0).setCellValue("투표제목");
        voteInfo1.createCell(1).setCellValue(StringUtils.defaultIfBlank((String) voteInfo.get("title"), ""));

        HSSFRow voteInfo2 = excelSheet.createRow(1);
        voteInfo2.createCell(0).setCellValue("투표상태");
        String status = StringUtils.defaultIfBlank((String) voteInfo.get("status"), "");
        if (status.equals("END")) {
            status = "투표종료";
        } else if (status.equals("START")) {
            status = "진행중";
        } else {
            status = "대기";
        }
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
        String nowDate = sdf.format(new Date());
        voteInfo2.createCell(1).setCellValue(status + "(" + nowDate + "기준)");

        HSSFRow voteInfo3 = excelSheet.createRow(2);
        voteInfo3.createCell(0).setCellValue("투표기간");
        String start_date = StringUtils.defaultIfBlank((String) voteInfo.get("start_date"), "");
        String end_date = StringUtils.defaultIfBlank((String) voteInfo.get("end_date"), "");
        String sd = start_date.substring(0, 4) + "." + start_date.substring(4, 6) + "." + start_date.substring(6, 8);
        String ed = end_date.substring(0, 4) + "." + end_date.substring(4, 6) + "." + end_date.substring(6, 8);
        voteInfo3.createCell(1).setCellValue(sd + " ~ " + ed);

        HSSFRow voteInfo4 = excelSheet.createRow(3);
        voteInfo4.createCell(0).setCellValue("투표자 총수");
        voteInfo4.createCell(1).setCellValue(voteInfo.get("voter_count") + "명");
    }

    // 투표결과 헤더
    public void setvoteResultExcelHeader(HSSFSheet excelSheet) {
        HSSFRow excelHeader = excelSheet.createRow(5);
        excelHeader.createCell(0).setCellValue("번호");
        excelHeader.createCell(1).setCellValue("제목");
        excelHeader.createCell(2).setCellValue("모바일");
        excelHeader.createCell(3).setCellValue("웹");
        excelHeader.createCell(4).setCellValue("전체득표수");
        excelHeader.createCell(5).setCellValue("백분율");
        excelHeader.createCell(6).setCellValue("예산액");
    }

    // 투표결과
    public void setvoteResultExcelRows(HSSFSheet excelSheet, List<HashMap> resultList) {
        int record = 6;
        HSSFCellStyle numcellStyle = workbook.createCellStyle();
        HSSFDataFormat format = workbook.createDataFormat();
        numcellStyle.setDataFormat(format.getFormat("#,##0"));
        HSSFCellStyle percellStyle = workbook.createCellStyle();
        percellStyle.setDataFormat(format.getFormat("#,##0.0%"));
        for (HashMap map : resultList) {
            HSSFRow excelRow = excelSheet.createRow(record++);
            int rownum = record - 6;
            HSSFCell cell_1 = excelRow.createCell(1);
            HSSFCell cell_2 = excelRow.createCell(2);
            HSSFCell cell_3 = excelRow.createCell(3);
            HSSFCell cell_4 = excelRow.createCell(4);
            HSSFCell cell_5 = excelRow.createCell(5);

            excelRow.createCell(0).setCellValue(rownum);// 번호
            cell_1.setCellValue(StringUtils.defaultIfBlank((String) map.get("biz_nm"), ""));
            cell_2.setCellValue(Integer.parseInt(StringUtils.defaultIfBlank(String.valueOf(map.get("mobile")), "0")));
            cell_2.setCellStyle(numcellStyle);
            cell_3.setCellValue(Integer.parseInt(StringUtils.defaultIfBlank(String.valueOf(map.get("pc")), "0")));
            cell_3.setCellStyle(numcellStyle);
            cell_4.setCellValue(Integer.parseInt(StringUtils.defaultIfBlank(String.valueOf(map.get("total")), "0")));
            cell_4.setCellStyle(numcellStyle);
            cell_5.setCellValue(Double.parseDouble(StringUtils.defaultIfBlank(String.valueOf(map.get("per")), "0.0")) / 100);
            cell_5.setCellStyle(percellStyle);
            excelRow.createCell(6).setCellValue(StringUtils.defaultIfBlank(String.valueOf(map.get("budget")), "0"));
        }
    }



    // 투표자
    public void setvoterResultExcelHeader(HSSFSheet excelSheet, HashMap voteInfo) {
        HSSFRow excelHeader = excelSheet.createRow(0);
        excelHeader.createCell(0).setCellValue("번호");
        excelHeader.createCell(1).setCellValue("투표시간");
        excelHeader.createCell(2).setCellValue("핸드폰번호");
        excelHeader.createCell(3).setCellValue("이메일");
        excelHeader.createCell(4).setCellValue("성별");
        excelHeader.createCell(5).setCellValue("지역");
        excelHeader.createCell(6).setCellValue("연령대");
        excelHeader.createCell(7).setCellValue("신분");
        excelHeader.createCell(8).setCellValue("회원");
        excelHeader.createCell(9).setCellValue("참여방식");
        int choice_cnt = Integer.parseInt(String.valueOf(voteInfo.get("choice_cnt")));
        int col = 10;
        for (int i = 1; i <= choice_cnt; i++) {
            excelHeader.createCell(col++).setCellValue("투표대상사업" + i);
        }
    }

    // 투표자
    public void setvoterResultExcelRows(HSSFSheet excelSheet, List<HashMap> resultList) {
        int record = 1;
        HSSFCellStyle numcellStyle = workbook.createCellStyle();
        HSSFDataFormat format = workbook.createDataFormat();
        numcellStyle.setDataFormat(format.getFormat("#,##0"));

        String encPhone = null;
        String encEmail = null;

        for (HashMap map : resultList) {
            HSSFRow excelRow = excelSheet.createRow(record++);
            int rownum = record - 1;
            HSSFCell cell_0 = excelRow.createCell(0); // 번호
            cell_0.setCellValue(rownum);
            cell_0.setCellStyle(numcellStyle);

            // 등록일
            String reg_date = StringUtils.defaultIfBlank((String) map.get("reg_date"), "");
            excelRow.createCell(1).setCellValue(reg_date.substring(0, 4) + "." + reg_date.substring(4, 6) + "." + reg_date.substring(6, 8) + " " + reg_date.substring(8, 10) + "시");

            //            excelRow.createCell(2).setCellValue(StringUtils.defaultIfBlank((String) map.get("phone"), "")); // 전화번호
            //            excelRow.createCell(3).setCellValue(StringUtils.defaultIfBlank((String) map.get("email"), "")); // 이메일
            encPhone = (String) map.get("phone");
            encEmail = (String) map.get("email");
            excelRow.createCell(2).setCellValue(XecureUtil.decString(encPhone)); // 복호화 전화번호
            excelRow.createCell(3).setCellValue(XecureUtil.decString(encEmail)); // 복호화 이메일

            // 성별
            String gender = StringUtils.defaultIfBlank((String) map.get("gender"), "");
            if (gender.equals("F")) {
                excelRow.createCell(4).setCellValue("여");
            } else {
                excelRow.createCell(4).setCellValue("남");
            }

            excelRow.createCell(5).setCellValue(StringUtils.defaultIfBlank((String) map.get("emd_nm"), "")); // 동이름
            excelRow.createCell(6).setCellValue(StringUtils.defaultIfBlank((String) map.get("age"), "") + "대"); // 나이

            // 나이그룹
            String age_group = StringUtils.defaultIfBlank((String) map.get("age_group"), "");
            if (age_group.equals(AgeGroup.ADULT.toString())) {
                excelRow.createCell(7).setCellValue("성인");
            } else if (age_group.equals(AgeGroup.YOUNG.toString())) {
                excelRow.createCell(7).setCellValue("청소년");
            } else {
                excelRow.createCell(7).setCellValue("기타");
            }

            // 회원 여부
            String user_type = StringUtils.defaultIfBlank((String) map.get("user_type"), "");
            if (user_type.equals(UserType.EMAIL.toString())) {
                excelRow.createCell(8).setCellValue("이메일회원");
                //            } else if (user_type.equals(UserType.PHONE.toString())) {
                //                excelRow.createCell(8).setCellValue("휴대폰회원");
            } else if (user_type.equals(UserType.CMIT.toString())) {
                excelRow.createCell(8).setCellValue("주민참여위원");
            } else {
                excelRow.createCell(8).setCellValue("기타 회원");
            }

            // 참여방식
            String vote_method = StringUtils.defaultIfBlank((String) map.get("vote_method"), "");
            if (vote_method.equals("MOBILE")) {
                excelRow.createCell(9).setCellValue("모바일");
            } else {
                excelRow.createCell(9).setCellValue("웹");
            }

            // 선택사업
            String biz_seq = StringUtils.defaultIfBlank((String) map.get("biz_seq"), ""); // 배열
            String[] biz_array = biz_seq.split(",");
            int biz_num = 10;
            for (String biz : biz_array) {
                excelRow.createCell(biz_num++).setCellValue(Integer.parseInt(biz));
            }
        }
    }

    // 정책제안 헤더
    public void setProposalExcelHeader(HSSFSheet excelSheet) {
        HSSFRow excelHeader = excelSheet.createRow(0);
        excelHeader.createCell(0).setCellValue("번호");
        excelHeader.createCell(1).setCellValue("제목");
        excelHeader.createCell(2).setCellValue("분야");
        excelHeader.createCell(3).setCellValue("등록자 이름");
        excelHeader.createCell(4).setCellValue("등록일");
        excelHeader.createCell(5).setCellValue("사업비");
        excelHeader.createCell(6).setCellValue("기간");
        excelHeader.createCell(7).setCellValue("첨부파일유무");
    }

    // 정책제안 결과
    public void setProposalExcelRows(HSSFSheet excelSheet, List<HashMap> resultList) {
        int record = 1;
        HSSFCellStyle numcellStyle = workbook.createCellStyle();
        HSSFDataFormat format = workbook.createDataFormat();
        numcellStyle.setDataFormat(format.getFormat("#,##0"));
        for (HashMap map : resultList) {
            HSSFRow excelRow = excelSheet.createRow(record++);
            int rownum = record - 1;
            HSSFCell cell_0 = excelRow.createCell(0); // 번호
            cell_0.setCellValue(rownum);
            cell_0.setCellStyle(numcellStyle);
            excelRow.createCell(1).setCellValue(StringUtils.defaultIfBlank((String) map.get("biz_nm"), "")); // 제목
            excelRow.createCell(2).setCellValue(StringUtils.defaultIfBlank((String) map.get("realm_nm"), ""));// 분야
            excelRow.createCell(3).setCellValue(StringUtils.defaultIfBlank((String) map.get("reg_name"), "")); // 작성자
            excelRow.createCell(4).setCellValue(StringUtils.defaultIfBlank((String) map.get("reg_date"), ""));// 등록일
            excelRow.createCell(5).setCellValue(StringUtils.defaultIfBlank((String) map.get("budget"), "0")); // 사업비
            excelRow.createCell(6).setCellValue(StringUtils.defaultIfBlank((String) map.get("start_date"), "") + "~" + StringUtils.defaultIfBlank((String) map.get("end_date"), ""));// 사업일
            // 파일유무
            excelRow.createCell(7).setCellValue(StringUtils.defaultIfBlank((String) map.get("file_yn"), ""));
        }
    }


}
