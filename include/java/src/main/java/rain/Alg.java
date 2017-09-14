package rain;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.stream.Stream;
import org.apache.commons.lang3.ArrayUtils;
import static java.lang.System.out;
import static java.util.stream.Collectors.counting;
import static java.util.stream.Collectors.groupingBy;

public class Alg {
  public static double EPSILON = 1e-8;

  // We do not put back, so num <= data.size();
  public static <Type> List<Type> sample(List<Type> data, int num) {
    if (num <= 0) {
      System.out.printf("Warning: sample size=%d <= 0\n", num);
      return new ArrayList<>();
    }
    if (num > data.size()) {
      System.out.printf("Warning: sample size=%d > data.size=%d\n",
                        num, data.size());
      return data.subList(0, data.size());
    }

    Collections.shuffle(data);
    return data.subList(0, num);
  }

  public static Writer openWriteFile(String fname) throws IOException {
    return new BufferedWriter(new FileWriter(fname));
  }

  public static Stream<String> openReadFileStream(String fname)
    throws IOException {
    return Files.lines(Paths.get(fname)).map(String::trim);
  }

  public static BufferedReader openReadFile(String fname) throws IOException {
    return new BufferedReader(new FileReader(fname));
  }

  public static Map<String, Long> countWords(Stream<String> strStream) {
    return strStream.collect(groupingBy(str-> str, counting()));
  }

  @Deprecated
  public static class IntComparator implements Comparator<Integer>,
                                               Serializable {
    @Override
    public int compare(Integer m, Integer n) {
      return Integer.compare(m, n);
    }
  }

  public static Map<String, String> extractAttribute(String[] blocks) {
    Map<String, String> ret = new TreeMap<>();
    for (String block: blocks) {
      int p = block.indexOf("=");
      if (p == -1) {
        out.println("found wrong block: " + block);
        return new TreeMap<>();
      }

      ret.put(block.substring(0, p), block.substring(p + 1));
    }
    return ret;
  }

  public static boolean eq(double a, double b) {
    return Math.abs(a - b) <= EPSILON;
  }

  public static boolean strictLess(double a, double b) {
    return !eq(a, b) && a < b;
  }

  public static boolean strictGreater(double a, double b) {
    return !eq(a, b) && a > b;
  }

  public static <Type> Type front(List<Type> list) {
    return list != null && !list.isEmpty() ? list.get(0) : null;
  }

  public static <Type> Type last(List<Type> list) {
    return list != null && !list.isEmpty() ? list.get(list.size() - 1) : null;
  }

  public static <Type> void resize(List<Type> list, int size, Type value) {
    while (list.size() < size) {
      list.add(value);
    }
    while (list.size() > size) {
      list.remove(list.size() - 1);
    }
  }

  public static double[] l1Norm(double[] weight, double norm) {
    double wsum = 0.;
    for (double w: weight) {
      wsum += Math.abs(w);
    }

    if (eq(wsum, 0)) {
      out.println("Warning in l1Norm: 0 vector found");
      return weight;
    }

    double ratio = norm / wsum;
    double[] ret = new double[weight.length];
    for (int p = 0; p < weight.length; ++p) {
      ret[p] = weight[p] * ratio;
    }
    return ret;
  }

  //public static <Type> void update(List<Type> data, int pos, Type value) {
  //data.set(pos, data.get(pos) + value);
  //}

  public static void main(String[] argv) {
    Timer timer = new Timer("Test Alg");
    out.println("Hello rain.Alg");

    //    List<Integer> list = Arrays.asList(1, 2, 3, 4, 5);
    //    out.println(Alg.front(list));
    //    out.println(Alg.last(list));

    List<Double> data = new ArrayList<>();
    Alg.resize(data, 10, 0.);
    out.println(data.size());

    double[] weights = {
      1, 2, 3, 4,
      };
    double[] weightsL1 = Alg.l1Norm(weights, 1.);
    //    out.println(Alg.last(weights));

    out.println(Arrays.asList(ArrayUtils.toObject(weightsL1)));

    out.println(Alg.extractAttribute("name=\tage=30   ".split("\t")));
    out.println(Alg.extractAttribute("n=n=summer\tage=30   ".split("\t")));

    String stream = "a b c d a b d g e 3 4 1 1 1 2 2 3";
    System.out.println(countWords(Arrays.stream(stream.split("\\s+"))));

    System.out.println("seconds: " + timer.getSeconds());
    System.out.println("minutes: " + timer.getMinutes());
    timer.reset();

    timer.stop();

    List<Integer> data1 = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8);
    System.out.println(sample(data1, 3));
    System.out.println(sample(data1, -1));
    System.out.println(sample(data1, 10));

  }
};
