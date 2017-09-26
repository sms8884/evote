/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.domain;

import java.io.Serializable;

import com.jaha.evote.domain.type.TermsType;

/**
 * <pre>
 * Class Name : Terms.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 8. 23.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 8. 23.
 * @version 1.0
 */
public class Terms implements Serializable {

    private static final long serialVersionUID = -6700458947774788780L;

    private int termsSeq;
    private TermsType termsType;
    private String termsTitle;
    private String termsCont;
    private String useYn;

    public int getTermsSeq() {
        return termsSeq;
    }

    public void setTermsSeq(int termsSeq) {
        this.termsSeq = termsSeq;
    }

    public TermsType getTermsType() {
        return termsType;
    }

    public void setTermsType(TermsType termsType) {
        this.termsType = termsType;
    }

    public String getTermsTitle() {
        return termsTitle;
    }

    public void setTermsTitle(String termsTitle) {
        this.termsTitle = termsTitle;
    }

    public String getTermsCont() {
        return termsCont;
    }

    public void setTermsCont(String termsCont) {
        this.termsCont = termsCont;
    }

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }

}
