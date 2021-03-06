#include <core.p4>
#include <v1model.p4>

header hdr {
    bit<8>  e;
    bit<16> t;
    bit<8>  l;
    bit<8>  r;
    bit<1>  v;
}

struct Header_t {
    hdr h;
}

struct Meta_t {
}

parser p(packet_in b, out Header_t h, inout Meta_t m, inout standard_metadata_t sm) {
    state start {
        b.extract<hdr>(h.h);
        transition accept;
    }
}

control vrfy(inout Header_t h, inout Meta_t m) {
    apply {
    }
}

control update(inout Header_t h, inout Meta_t m) {
    apply {
    }
}

control egress(inout Header_t h, inout Meta_t m, inout standard_metadata_t sm) {
    apply {
    }
}

control deparser(packet_out b, in Header_t h) {
    apply {
        b.emit<hdr>(h.h);
    }
}

control ingress(inout Header_t h, inout Meta_t m, inout standard_metadata_t standard_meta) {
    @name("ingress.a") action a_0() {
        standard_meta.egress_spec = 9w0;
    }
    @name("ingress.a_with_control_params") action a_with_control_params_0(bit<9> x) {
        standard_meta.egress_spec = x;
    }
    @name("ingress.t_range") table t_range {
        key = {
            h.h.r: range @name("h.h.r") ;
        }
        actions = {
            a_0();
            a_with_control_params_0();
        }
        default_action = a_0();
        const entries = {
                        8w1 .. 8w8 : a_with_control_params_0(9w21);

                        8w6 .. 8w12 : a_with_control_params_0(9w22);

                        default : a_with_control_params_0(9w23);

        }

    }
    apply {
        t_range.apply();
    }
}

V1Switch<Header_t, Meta_t>(p(), vrfy(), ingress(), egress(), update(), deparser()) main;

