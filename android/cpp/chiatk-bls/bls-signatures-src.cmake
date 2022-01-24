CMAKE_MINIMUM_REQUIRED(VERSION 3.1.0 FATAL_ERROR)
set (CMAKE_CXX_STANDARD 14)

file(GLOB HEADERS ${CMAKE_CURRENT_SOURCE_DIR}/*.hpp)
source_group("SrcHeaders" FILES ${HEADERS})

include_directories(
  ${INCLUDE_DIRECTORIES}
  ${CMAKE_CURRENT_SOURCE_DIR}/bls-signatures/contrib/relic/include
  ${CMAKE_BINARY_DIR}/bls-signatures/src/contrib/relic/include
  ${CMAKE_CURRENT_SOURCE_DIR}/bls-signatures/src/contrib/catch
  )

set(C_LIB ${CMAKE_BINARY_DIR}/libbls.a)

add_library(bls ${CMAKE_CURRENT_SOURCE_DIR}/bls-signatures/src/bls.cpp)

add_library(blstmp ${HEADERS}
  ${CMAKE_CURRENT_SOURCE_DIR}/bls-signatures/src/elements.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/bls-signatures/src/schemes.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/bls-signatures/src/privatekey.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/bls-signatures/src/bls.cpp
)

set(OPREFIX object_)
find_library(GMP_NAME NAMES libgmp.a gmp)
find_library(SODIUM_NAME NAMES libsodium.a sodium)



#set(LIBRARIES_TO_COMBINE
#      COMMAND mkdir ${OPREFIX}$<TARGET_NAME:blstmp> || true && cd ${OPREFIX}$<TARGET_NAME:blstmp> &&  ${CMAKE_AR} -x $<TARGET_FILE:blstmp>
#      COMMAND mkdir ${OPREFIX}$<TARGET_NAME:relic_s> || true && cd ${OPREFIX}$<TARGET_NAME:relic_s> &&  ${CMAKE_AR} -x $<TARGET_FILE:relic_s>
#)

if (GMP_FOUND)
  list(APPEND LIBRARIES_TO_COMBINE COMMAND mkdir ${OPREFIX}gmp || true && cd ${OPREFIX}gmp &&  ${CMAKE_AR} -x ${GMP_NAME})
endif()
if (SODIUM_FOUND)
  list(APPEND LIBRARIES_TO_COMBINE COMMAND mkdir ${OPREFIX}sodium || true && cd ${OPREFIX}sodium &&  ${CMAKE_AR} -x ${SODIUM_NAME})
endif()

#add_custom_target(combined_custom
#        ${LIBRARIES_TO_COMBINE}
#        COMMAND ${CMAKE_AR} -rs ${C_LIB} ${OPREFIX}*/*${CMAKE_C_OUTPUT_EXTENSION}
#        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
#        DEPENDS blstmp relic_s
#        )

#add_library(combined STATIC IMPORTED GLOBAL)
#add_dependencies(combined combined_custom)

#target_link_libraries(bls combined)

#set_target_properties(combined
#        PROPERTIES
#        IMPORTED_LOCATION ${C_LIB}
#        )

file(GLOB includes "${CMAKE_CURRENT_SOURCE_DIR}/*.hpp")
install(FILES ${includes} DESTINATION include/chiabls)
install(FILES ${C_LIB} DESTINATION lib)

#add_executable(runtest test.cpp)
#add_executable(runbench test-bench.cpp)

#if (SODIUM_FOUND)
#  target_link_libraries(runtest blstmp relic_s sodium)
#  target_link_libraries(runbench blstmp relic_s sodium)
#else()
#  target_link_libraries(runtest blstmp relic_s)
#  target_link_libraries(runbench blstmp relic_s)
#endif()