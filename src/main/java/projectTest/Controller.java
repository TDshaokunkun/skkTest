package projectTest;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
 
@RestController
public class Controller {
    @GetMapping("/run")
    public String run() {
        return "Hello SpringBoot";
    }
}