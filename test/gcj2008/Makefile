FLAGS=
OUT=cheating_boolean_tree triangle_areas perm_rle text_messaging_outrage minimum_scalar_product save_universe

%: %.s

%.s: %.dna
	../../danac $(FLAGS) $^

%.o: %.s
	as -o $@ $^

%: %.o
	ld -o $@ $^ ../../lib/danalib.a

all: $(OUT)

#all: $(addsuffix .s,$(OUT))

.PHONY: clean

clean:
	rm -f $(OUT) $(addsuffix .s,$(OUT)) $(addsuffix .imm,$(OUT))
