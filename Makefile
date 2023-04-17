# include
include mk/config.mk			# base config
include mk/utils.mk				# utils function / var
include mk/lib.mk				# load lib if needed
include mk/srcs.mk				# srcs.mk
include mk/pb.mk				# ui thing, progress bar etc

$(call PB_INIT)

# rule
## config
.SILENT:

.PHONY: setup

.DEFAULT: all

all:			setup $(TARGET)

bonus:			setup $(TARGET)

### TARGETS
$(TARGET):		$(LIBFT) $(MINI_LIBX) $(OBJ_C)
> $(call P_INF,Creating $(R)$(TARGET)$(RST))
> $(call PB_PRINT_ELAPSED)
> $(CC) $(CFLAGS) -o $@ $(OBJ_C) $(LIBS)
> $(call PB_TARGET_DONE)

## objs
# https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html#Automatic-Variables
# $(<)		: dependencies
# $(@)		: full target
# $(@D)		: dir target
$(OBJ_C):		$(OBJ_DIR)/%.o:$(SRC_DIR)/%.c
> $(call PB_PRINT,$(@))
> gcc $(CFLAGS) -o $@ -c $<

### LIBS
$(LIBFT):
ifeq ($(USE_LIBFT),1)
> make -C lib/ft_libft all
endif

$(MINI_LIBX):
ifeq ($(USE_MINI_LIBX),1)
> make -C lib/minilibx-linux all
endif

setup:	$(BIN_DIR) print_logo print_debug

$(BIN_DIR):
> $(call MKDIR,$(BIN_DIR))

print_debug:
ifeq ($(shell [ $(DEBUG) -ge 1 ] && printf 1 || printf 0),1)
> $(call P_INF,RUNTIME INFOS)
> printf "\t%s"
> $(call P_WAR,DEBUG: $(DEBUG))
> printf "\t%s"
> $(call P_WAR,CFLAGS:)
> printf "\t\t%s\n" $(CFLAGS)
> printf "\t%s"
> $(call P_WAR,.SHELLFLAGS:)
> printf "\t\t%s\n"  $(.SHELLFLAGS)
> printf "\t%s"
> $(call P_WAR,OBJ_C:)
> printf "\t\t%s\n"  $(OBJ_C)
> printf "\t%s"
> $(call P_WAR,SRC_C:)
> printf "\t\t%s\n"  $(SRC_C)
endif

print_logo:
ifeq ($(LOGO_PRINTED),)
> $(call P_ANSI,)
> printf "%b\n" $(ASCII_COLOR)"$$ASCII_BANNER$(RST)"
> $(eval export LOGO_PRINTED=1)
endif

ft_helper:
> ./scripts/ft_helper/ft_helper

### RUN
run:					re
> ./$(TARGET)

### CLEAN
clean:
> $(call P_FAI,Removing obj)
> rm -rf $(OBJ_DIR)

clean_all:				clean
> make -C lib/ft_libft clean
> make -C lib/minilibx-linux clean

fclean:							clean
ifeq ($(BONUS),1)
> $(call P_FAI,Removing $(TARGET))
> rm -rf $(TARGET)
else
> $(call P_FAI,Removing $(TARGET_BONUS))
> rm -rf $(TARGET_BONUS)
endif

fclean_all:				fclean
> make -C lib/ft_libft fclean
> make -C lib/minilibx-linux clean

### RE
re:						setup fclean $(TARGET)

re_all:					re_lib re

re_lib:
> make -C ./lib/ft_libft re
> make -C ./lib/minilibx-linux re
