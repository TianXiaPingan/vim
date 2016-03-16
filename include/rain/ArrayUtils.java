package rain;

public class ArrayUtils {
  public static void reverse(int[] data, int f, int t) {
    while (f < t - 1) {
      int v = data[f];
      data[f++] = data[t - 1];
      data[t-- - 1] = v;
    }
  }

  public static void display(int[] data, int f, int t) {
    for (int p = f; p < t; ++p) {
      System.out.print(data[p] + " ");
    }
    System.out.println();
  }
};
