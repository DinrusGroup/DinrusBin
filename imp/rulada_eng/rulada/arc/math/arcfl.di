module arc.math.arcfl; 

public{
/// in case user wants to upgrade precision to say.. double 
alias float arcfl; 
}
version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
