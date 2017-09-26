package com.jaha.evote.common.util;

/**
 * <pre>
 * Class Name : NumberUtils.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 7. 22.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 7. 22.
 * @version 1.0
 */
public class NumberUtils extends org.apache.commons.lang3.math.NumberUtils {

	public static Integer toInteger(String src, Integer defaultValue) {
		if(src == null) {
			return defaultValue;
		}

		try {
			return Integer.valueOf(src);
		} catch (Exception e) {
			return defaultValue;
		}

	}

    /**
     * <pre>
     * Parses the int.
     * </pre>
     *
     * @param src the src
     *
     * @return the int
     */
    public static int parseInt(String src) {
        return parseInt(src, -1);
    }

    /**
     * <pre>
     * Parses the int.
     * </pre>
     *
     * @param src the src
     * @param dft the dft
     *
     * @return the int
     */
    public static int parseInt(String src, int dft) {
        int result = dft;
        try {
            result = Integer.parseInt(src);
        } catch (NumberFormatException e) {
        	e.printStackTrace();
            result = dft;
        }
        return result;
    }

    /**
     * <pre>
     * Parses the long.
     * </pre>
     *
     * @param src the src
     *
     * @return the long
     */
    public static long parseLong(String src) {
        return parseLong(src, -1L);
    }

    /**
     * <pre>
     * Parses the long.
     * </pre>
     *
     * @param src the src
     * @param dft the dft
     *
     * @return the long
     */
    public static long parseLong(String src, long dft) {
        long result = dft;
        try {
            result = Long.parseLong(src);
        } catch (NumberFormatException e) {
        	e.printStackTrace();
            result = dft;
        }
        return result;
    }

    /**
     * <pre>
     * Parses the double.
     * </pre>
     *
     * @param src the src
     *
     * @return the double
     */
    public static double parseDouble(String src) {
        return parseDouble(src, -1D);
    }

    /**
     * <pre>
     * Parses the double.
     * </pre>
     *
     * @param src the src
     * @param dft the dft
     *
     * @return the double
     */
    public static double parseDouble(String src, double dft) {
        double result = dft;
        try {
            result = Double.parseDouble(src);
        } catch (NumberFormatException e) {
        	e.printStackTrace();
            result = dft;
        }
        return result;
    }

    /**
     * <pre>
     * Floor.
     * </pre>
     *
     * @param a the a
     *
     * @return the double
     */
    public static double floor(float a) {
        return Math.floor(a);
    }

    /**
     * <pre>
     * Floor.
     * </pre>
     *
     * @param a the a
     *
     * @return the double
     */
    public static double floor(double a) {
        return Math.floor(a);
    }

    /**
     * <pre>
     * Round.
     * </pre>
     *
     * @param a the a
     *
     * @return the int
     */
    public static int round(float a) {
        return Math.round(a);
    }

    /**
     * <pre>
     * Round.
     * </pre>
     *
     * @param a the a
     *
     * @return the long
     */
    public static long round(double a) {
        return Math.round(a);
    }

    /**
     * <pre>
     * Ceil.
     * </pre>
     *
     * @param a the a
     *
     * @return the double
     */
    public static double ceil(float a) {
        return Math.ceil(a);
    }

    /**
     * <pre>
     * Ceil.
     * </pre>
     *
     * @param a the a
     *
     * @return the double
     */
    public static double ceil(double a) {
        return Math.ceil(a);
    }


    /**
     * <pre>
     * Random.
     * </pre>
     *
     * @return the double
     */
    public static double random() {
        return Math.random();
    }

    /**
     * <pre>
     * Max.
     * </pre>
     *
     * @param a the a
     * @param b the b
     *
     * @return the int
     */
    public static int max(int a, int b) {
        return Math.max(a, b);
    }

    /**
     * <pre>
     * Max.
     * </pre>
     *
     * @param a the a
     * @param b the b
     *
     * @return the long
     */
    public static long max(long a, long b) {
        return Math.max(a, b);
    }

    /**
     * <pre>
     * Max.
     * </pre>
     *
     * @param a the a
     * @param b the b
     *
     * @return the float
     */
    public static float max(float a, float b) {
        return Math.max(a, b);
    }

    /**
     * <pre>
     * Max.
     * </pre>
     *
     * @param a the a
     * @param b the b
     *
     * @return the double
     */
    public static double max(double a, double b) {
        return Math.max(a, b);
    }

    /**
     * <pre>
     * Min.
     * </pre>
     *
     * @param a the a
     * @param b the b
     *
     * @return the int
     */
    public static int min(int a, int b) {
        return Math.min(a, b);
    }

    /**
     * <pre>
     * Min.
     * </pre>
     *
     * @param a the a
     * @param b the b
     *
     * @return the long
     */
    public static long min(long a, long b) {
        return Math.min(a, b);
    }

    /**
     * <pre>
     * Min.
     * </pre>
     *
     * @param a the a
     * @param b the b
     *
     * @return the float
     */
    public static float min(float a, float b) {
        return Math.min(a, b);
    }

    /**
     * <pre>
     * Min.
     * </pre>
     *
     * @param a the a
     * @param b the b
     *
     * @return the double
     */
    public static double min(double a, double b) {
        return Math.min(a, b);
    }
}
