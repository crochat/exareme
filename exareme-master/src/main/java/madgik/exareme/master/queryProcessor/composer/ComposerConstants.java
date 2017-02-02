package madgik.exareme.master.queryProcessor.composer;

import org.apache.log4j.Logger;

import madgik.exareme.utils.properties.AdpProperties;

/**
 * @author alex
 */
public class ComposerConstants {
  private static final Logger log = Logger.getLogger(ComposerConstants.class);

  public static final String algorithmKey = "algorithm_key";
  public static final String inputLocalTblKey = "input_local_tbl";
  public static final String inputGlobalTblKey = "input_global_tbl";
  public static final String outputGlobalTblKey = "output_tbl";
  public static final String outputPrvGlobalTblKey = "prv_output_global_tbl";
  public static final String isTmpKey = "isTmp";
  public static final String algorithmIterKey = "algorithm_iter_key";
  public static final String demoDirectory;
  public static final String demoDbWorkingDirectory;
  public static final String defaultDBKey = "defaultDB";


  static {
    demoDirectory = AdpProperties.getGatewayProperties().getString("demo.directory");
    demoDbWorkingDirectory = demoDirectory + "db/";
  }
}
