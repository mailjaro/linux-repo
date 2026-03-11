# ===================================================================
# Makefile for LINUX project
# ===================================================================

# Default goal
.DEFAULT_GOAL := all

# Unknown or misprinted target:
.DEFAULT:
	@echo "Unknown target: $@"
	@echo
	@$(MAKE) --no-print-directory help


# ===================================================================
# Variabler
# ===================================================================

# CONFIGSuration
CHAPTERS        :=  chapters
BUILD           :=  builds
STYLES          :=  styles
CONFIGS         := configs
IMAGES          :=  images
MASTERHTML      :=  $(CONFIGS)/masterHTML.adoc
MASTER_E_LIGHT  :=  $(CONFIGS)/masterEPUB-light.adoc
MASTER_E_DARK   :=  $(CONFIGS)/masterEPUB-dark.adoc
MASTERPDF       :=  $(CONFIGS)/masterPDF.adoc
DARKPUB         :=  $(STYLES)/epub-dark.css
LIGHTPUB        :=  $(STYLES)/epub-light.css
COVER           :=  $(IMAGES)/cover.png
COMMON          :=  $(CONFIGS)/common.yaml

# Outputs
EPUB_PAN_LIGHT := $(BUILD)/linux-pan-light.epub
EPUB_PAN_DARK  := $(BUILD)/linux-pan-dark.epub
EPUB_ASC_LIGHT := $(BUILD)/linux-asc-light.epub
EPUB_ASC_DARK  := $(BUILD)/linux-asc-dark.epub
HTML := $(BUILD)/linux.html
PDF  := $(BUILD)/linux.pdf


# ===================================================================
# Rules
# ===================================================================


# Ensure build directory exists -------------------------------------
$(BUILD):
	@mkdir -p $@
# -------------------------------------------------------------------


# --- Phony targets -----------------------------------------------------
.PHONY: all clean html pdf ep_light ep_dark ea_light ea_dark help md2adoc
#------------------------------------------------------------------------


# --- Produce all formats ----------------------
all: ep_light ep_dark ea_light ea_dark html pdf 
# ----------------------------------------------


# --- Produce EPUBs fram MD with pandoc ------------------

# --- Light version -----
ep_light: $(EPUB_PAN_LIGHT)   # Alias for langt navn
$(EPUB_PAN_LIGHT): $(MD) | $(BUILD)
# 	@pandoc $< --metadata-file=$(COMMON) \
# 	       --css=$(LIGHTPUB) \
# 		   --metadata cover-image=$(COVER) \
# 	       -o $@
# 	@echo "✅ Light EPUB successfully produced by pandoc."

# --- Dark version ----------------------------------------
ep_dark: $(EPUB_PAN_DARK)   # Alias for langt navn
$(EPUB_PAN_DARK): $(MD) | $(BUILD)
# 	@pandoc $< --metadata-file=$(COMMON) \
# 	       --css=$(DARKPUB) \
# 		   --metadata cover-image=$(COVER) \
# 	       -o $@
# 	@echo "✅ Dark EPUB successfully produced by pandoc."
# ---------------------------------------------------------


# ---- Produce ADOCs from MDs with pandoc ---
md2adoc:
	bash chapters/md-2-adoc.sh
	echo "Done ADOCs"
# --------------------------------------------


# --- Produce ADOC(2), +admonitions -emojis ------
$(ADOC2): $(ADOC1)
	@cp $< $@
	@sd '❗' 'NOTE:' $@
	@sd '‼️' 'CAUTION:' $@
	@sd '🚩' 'WARNING:' $@
	@sd '\p{Extended_Pictographic}\uFE0F? ' '' $@
	@sd ' [1-7]️⃣' '' $@
# ------------------------------------------------


# --- Produce ADOC(3), PDF-friendly version -------------------------
$(ADOC3): $(ADOC2)
	@cp $< $@
	@sd '\[source,text\]' '[%unbreakable]\n[source,text]' $@
	@sd '\[source,makefile\]' '[%unbreakable]\n[source,text]' $@
	@sd '\[source,bash\]' '[%unbreakable]\n[source,bash]' $@
#--------------------------------------------------------------------


# --- Produce all main formats ------------------------------------------

# Note: These epubs use adoc3, not the usual adoc2. Check the masterfile
ea_light: $(EPUB_ASC_LIGHT)   # Alias for langt navn
$(EPUB_ASC_LIGHT): $(ADOC3) | $(BUILD)
	@asciidoctor-epub3 $(MASTER_E_LIGHT) -R . -o $@
	@echo "✅ Light EPUB successfully produced by asciidoctor."

ea_dark: $(EPUB_ASC_DARK)   # Alias for langt navn
$(EPUB_ASC_DARK): $(ADOC3) | $(BUILD)
	@asciidoctor-epub3 $(MASTER_E_DARK) -R . -o $@
	@echo "✅ Dark EPUB successfully produced by asciidoctor."

html: $(HTML)
$(HTML): $(ADOC3) | $(BUILD) 
	@asciidoctor $(MASTERHTML) -R . -a data-uri -o $@
	@echo "✅ HTML successfully produced by asciidoctor."

pdf: $(PDF)
$(PDF): $(ADOC3) | $(BUILD)
	@asciidoctor-pdf $(MASTERPDF) -R . -o $@
	@echo "✅ PDF successfully produced by asciidoctor."
# ------------------------------------------------------------------------


# Remove output-formats and intermediate files ----
clean:
	@rm -f $(BUILD)/*.* $(ADOC1) $(ADOC2) $(ADOC3)
# Husk: Fjern adocs på chapters
	@echo "✅ Cleaned build artifacts."
#--------------------------------------------------


# Help screen ----------------------------------------------------------
help:
	@echo "➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖"
	@echo "help                :produce this output"
	@echo "make                :produce all formats"
	@echo "make all            :produce all formats"
	@echo "make html           :produce HTML format"
	@echo "make pdf            :produce PDF format"
	@echo "make ep_light       :produce light EPUB with pandoc"
	@echo "make ep_dark        :produce dark  EPUB with pandoc"
	@echo "make ea_light       :produce light EPUB with asciidoctor"
	@echo "make ea_dark        :produce dark  EPUB with asciidoctor"
	@echo "make makef-1.adoc   :produce ADOC(1) from MD"
	@echo "make makef-2.adoc   :produce ADOC(2), no emojis"
	@echo "make makef-3.adoc   :produce ADOC(3), PDF-friendly version"
	@echo ""
	@echo "To force evaluation use option -B."
	@echo "For a dry run use option -n."
	@echo "➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖"
	