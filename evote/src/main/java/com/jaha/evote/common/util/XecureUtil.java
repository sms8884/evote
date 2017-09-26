package com.jaha.evote.common.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.softforum.xdbe.XdspNative;

@Component
public class XecureUtil {

    private static final Logger logger = LoggerFactory.getLogger(XecureUtil.class);

    private static String SECU_POOL_NAME;
    private static String SECU_DB_NAME;
    private static String SECU_OWNER_NAME;
    private static String SECU_TABLE_NAME;
    private static String SECU_COLUMN_NAME;

    @Value("${xecuredb.secu.pool.name}")
    public void setSecuPoolName(String secuPoolName) {
        SECU_POOL_NAME = secuPoolName;
    }

    @Value("${xecuredb.secu.db.name}")
    public void setSecuDbName(String secuDbName) {
        SECU_DB_NAME = secuDbName;
    }

    @Value("${xecuredb.secu.owner.name}")
    public void setSecuOwnerName(String secuOwnerName) {
        SECU_OWNER_NAME = secuOwnerName;
    }

    @Value("${xecuredb.secu.table.name}")
    public void setSecuTableName(String secuTableName) {
        SECU_TABLE_NAME = secuTableName;
    }

    @Value("${xecuredb.secu.column.name}")
    public void setSecuColumnName(String secuColumnName) {
        SECU_COLUMN_NAME = secuColumnName;
    }

    public static String encString(String text) {
        if (text == null) {
            return null;
        }
        try {
            text = XdspNative.fast_sync_encrypt64(SECU_POOL_NAME, SECU_DB_NAME, SECU_OWNER_NAME, SECU_TABLE_NAME, SECU_COLUMN_NAME, text.getBytes());
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
        return text;
    }

    public static String decString(String text) {
        if (text == null) {
            return null;
        }

        try {
            byte[] sDecrypt = XdspNative.fast_sync_decrypt64(SECU_POOL_NAME, SECU_DB_NAME, SECU_OWNER_NAME, SECU_TABLE_NAME, SECU_COLUMN_NAME, text);
            text = new String(sDecrypt);
        } catch (Exception e) {
            logger.error(e.getMessage());
        }

        return text;
    }

    public static String hash64(String plainText) {
        try {
            return XdspNative.hash64(XdspNative.XDSP_API_HASH_ALGID_SHA1, plainText.getBytes());
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
        return plainText;
    }

    public static boolean verifyHash64(String plainText, String encryptedText) {
        try {
            return !(plainText == null || encryptedText == null) && encryptedText.equals(XdspNative.hash64(XdspNative.XDSP_API_HASH_ALGID_SHA1, plainText.getBytes()));
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
        return false;
    }

}
