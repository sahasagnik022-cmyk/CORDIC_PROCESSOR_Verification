# =====================================================================
# VCS / UVM Regression Makefile
# =====================================================================

TESTLIST = dir_angle_0_deg dir_angle_90_deg dir_angle_180_deg \
           dir_angle_270_deg dir_angle_max_deg dir_mult_neg_neg \
           dir_mult_pos_neg dir_mult_zero rand_mult_full_sweep \
           rand_angle_full_sweep rand_mixed_mode_back_to_back  \
                   dir_mult_corners_test err_injection_test

NUM_RUNS      = 8
UVM_VERBOSITY = UVM_LOW
CM_OPTS       = -cm line+cond+fsm+tgl+branch+assert

REGR_DIR      = regression_cm
MERGED_DIR    = $(REGR_DIR)/merged

.PHONY: all compile run regression clean

all: compile

# 1. Compile the Testbench
compile:
                vcs -full64 -sverilog -ntb_opts uvm -licqueue \
                -kdb -fsdb -debug_access+all \
                $(CM_OPTS) -assert svaext -lca -assert enable_diag \
                tb_top.sv -l compile.log

# 2. Run a single test for debugging
run: compile
                ./simv $(CM_OPTS) -cm_dir single_run.vdb -cm_name $(TEST) -assert nopostproc \
                +UVM_TESTNAME=$(TEST) +UVM_VERBOSITY=$(UVM_VERBOSITY) -l $(TEST).log
                urg -dir simv.vdb -dir single_run.vdb -report single_report
                @echo ">>> Single run complete! Open single_report/dashboard.html"

# 3. Automated Regression
regression: compile
        @mkdir -p $(REGR_DIR)
        @rm -f $(REGR_DIR)/vdb_list.txt $(REGR_DIR)/failed_runs.txt
        @for t in $(TESTLIST); do \
                for i in $$(seq 1 $(NUM_RUNS)); do \
                        EXTRA_ARGS=""; \
                        if [ "$$t" = "rand_mixed_mode_back_to_back" ]; then \
                                EXTRA_ARGS="+MID_TEST_RESET"; \
                        fi; \
                        if [ "$$t" = "err_injection_test" ]; then \
                                EXTRA_ARGS="+uvm_set_type_override=cordic_driver_2,cordic_error_driver"; \
                        fi; \
                        echo "Running $$t (Run $$i/$(NUM_RUNS))..."; \
                        ./simv $(CM_OPTS) -cm_dir $(REGR_DIR)/$${t}_$${i}.vdb \
                        -cm_name $${t}_$${i} \
                        -assert nopostproc \
                        +UVM_TESTNAME=$$t +ntb_random_seed_automatic +UVM_VERBOSITY=$(UVM_VERBOSITY) \
                        $$EXTRA_ARGS \
                        -l $(REGR_DIR)/$${t}_$${i}.log; \
                        if [ -d "$(REGR_DIR)/$${t}_$${i}.vdb" ]; then \
                                echo "-dir $(REGR_DIR)/$${t}_$${i}.vdb" >> $(REGR_DIR)/vdb_list.txt; \
                        else \
                                echo "!!! FAILED TO GENERATE VDB: $$t (Run $$i) - Check log!" | tee -a $(REGR_DIR)/failed_runs.txt; \
                        fi; \
                done; \
        done
        @echo ">>> Merging Coverage..."
        urg -dir simv.vdb $$(cat $(REGR_DIR)/vdb_list.txt) -dbname $(MERGED_DIR)/merged_cov.vdb -report $(MERGED_DIR)/html_report
        @echo ">>> Regression Complete! Coverage merged successfully."

# 4. Clean up all generated files
clean:
                rm -rf simv* csrc *.log urgReport DVEfiles ucli.key single_run* single_report $(REGR_DIR)
